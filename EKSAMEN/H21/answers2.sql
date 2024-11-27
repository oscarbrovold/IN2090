-- Oppgave 2.2 - Store stjerner
-- Skriv en SQL-spørring som finner navn, masse og lysstyrke på alle stjerner som
-- har masse større enn 200 eller lysstyrke større enn 10.

SELECT s.navn, s.masse, s.lysstyrke
FROM stjerne s
WHERE s.masse > 200 OR s.lysstyrke > 10;

-- Oppgave 2.3 - Planeter i solsystemet
-- Skriv en SQL-spørring som finner navn og masse på planeter som er i samme
-- solsystem som planeten med navn 'Tellus'. Sorter resultatet etter masse fra minst til størst

SELECT p.navn, p.masse
FROM planet p
WHERE p.sid = (
	SELECT sid
	FROM planet 
	WHERE navn = 'Tellus')
ORDER BY p.masse;

-- ev.

SELECT p2.navn, p2.masse
FROM planet p1 
JOIN planet p2 USING (sid)
WHERE p1.navn = 'Tellus'
ORDER BY p2.masse;

-- Oppgave 2.4 - Pund til kilo

-- Det viser seg at observatoriet med navn 'BESS' konsekvent har rapportert
-- massen på alle sine observasjoner av stjerner gjort før '1990' i pund fremfor
-- kilo. Skriv derfor en SQL-kommando som oppdaterer massen til alle stjerner
-- observert før dette året av dette observatoriet til kilogram. Merk at ett pund er
-- 0.45 kilogram, altså blir ny masse lik 0.45 ganger tidligere masse.

UPDATE stjerne
SET masse = masse * 0.45
WHERE oppdaget < 1990 AND oid = (
	SELECT oid
	FROM observator
	WHERE navn = 'BESS')

-- Oppgave 2.5 - Universet
-- Skriv en SQL-kommando som lager et VIEW med navn universet som inneholder
-- to kolonner: det totale antallet astronomiske objekter i universet (altså totalt
-- antall stjerner, planeter og måner som er i databasen), samt den totale massen
-- til universet (altså den totale massen til alle disse objektene i databasen).

CREATE VIEW universet AS (

WITH tot_stjerner AS (
SELECT count(*) AS antall, sum(masse) AS tot_masse
FROM stjerne),

tot_planeter AS (
SELECT count(*) AS antall, sum(masse) AS tot_masse
FROM planet),

tot_måner AS (
SELECT count(*) AS antall, sum(masse) AS tot_masse
FROM måne),

tot_astronomiske_objekter AS (
(SELECT *
FROM tot_stjerner)
UNION ALL
(SELECT *
FROM tot_planeter)
UNION ALL
(SELECT *
FROM tot_måner))

SELECT sum(antall), sum(tot_masse)
FROM tot_astronomiske_objekter);

-- Oppgave 2.6 - Store solsystemer
-- Et solsystem er en mengde astronomiske objekter som går i bane rundt en stjerne,
-- altså alle planetene som går i bane rundt stjernen samt alle disse planetenes måner.
-- Skriv en SQL-spørring som finner navn på alle stjerner som er en del av et stort
-- solsystem, hvor et stort solsystem er et solsystem med mer enn 10 planeter eller
-- som har total masse (på både stjernen, planetene og månene til sammen) på
-- mer enn 400.

WITH måne_masser AS (
SELECT p.sid, m.pid, sum(m.masse) AS masse_måner
FROM måne m
JOIN planet p USING (pid)
GROUP BY m.pid, p.sid),
planet_masser AS (
SELECT p.sid, sum(p.masse) AS masse_planeter
FROM planet p
GROUP BY p.sid),
solsystem_masse AS (
SELECT s.sid
FROM måne_masser mm
JOIN planet_masser pm USING (sid)
JOIN stjerne s USING (sid)
WHERE mm.masse_måner + pm.masse_planeter + s.masse > 400),
mer_enn_10_planeter AS (
SELECT sid
FROM planet
GROUP BY sid
HAVING count(pid) > 10)

SELECT navn
FROM stjerne
WHERE sid IN mer_enn_10_planeter OR sid IN solsystem_masse;





