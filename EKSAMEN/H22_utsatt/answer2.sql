-- Oppgave 2.2 - Åpninger
-- Skriv en spørring som finner pid og tiden brukt på alle trekk som enten er 'e4'
-- eller 'c3' og som er på første tur (altså tur 1).

SELECT pid, tid_brukt
FROM trekk
WHERE tur = 1 AND (trekk = 'e4' OR trekk = 'c3');

-- Oppgave 2.3 - Skakk-matt vinnere
-- Skriv en SQL-spørring som finner navn på alle spillere som har vunnet med sorte
-- brikker i turneringen med navn 'Skakk-matt'. Svaret skal kun inneholde unike navn.


SELECT DISTINCT s.navn
FROM spiller s
JOIN parti p ON (s.sid = p.sort)
JOIN turnering t USING (tid)
WHERE t.navn = 'Skakk-matt' AND p.vinner = 'sort';

-- Oppgave 2.4 - Korte partier
-- Skriv en SQL-spørring som finner pid, vinner og antall trekk for hvert parti,
-- men kun for de partiene med færre enn (eller lik) 10 trekk (spørringen skal også
-- ha med de som ikke har noen trekk med antall lik 0).

SELECT p.pid, p.vinner, count(t.trekk) AS antall_trekk
FROM parti p 
LEFT JOIN trekk t USING (pid)
GROUP BY p.pid, p.vinner
HAVING antall_trekk <= 10;

-- Oppgave 2.5 - Ny spiller

-- Skriv en SQL-kommando som setter inn en ny spiller med navn 'Mona', som har
-- sid-verdi lik 1 pluss høyeste sid-verdi allerede i spiller-tabellen, og som har
-- rating lik gjennomsnitts-ratingen til alle spillerene allerede i spiller-tabellen
-- som har spilt minst ett parti.

INSERT INTO spiller

SELECT (SELECT max(sid) + 1 FROM spiller) AS sid,
'Mona' AS navn,
(SELECT avg(rating) 
FROM spiller 
WHERE sid IN (SELECT hvit FROM parti) 
OR sid IN (SELECT sort FROM parti)) AS rating;

-- Oppgave 2.6 - Populære åpninger
-- Skriv en spørring som finner det mest populære åpningstrekket (altså det vanligste
-- trekket for tur lik 1) for hver spilltype (altså 'lynsjakk', ‘hurtigsjakk’, osv.).
-- Resultatet skal også inneholde det mest populære trekket for partier som ikke
-- er tilknyttet noen turnering, og du kan da la spilltype være 'uavhengig' i resultatet.
-- Merk: Det kan finnes flere spilltyper i databasen enn de som er listet i eksempeldataene.

WITH sub AS (
SELECT t.spilletype, k.trekk, count(*) AS antall
FROM trekk k
JOIN parti p USING (pid)
LEFT JOIN turnering t USING (tid)
WHERE k.tur = 1
GROUP BY t.spilletype, k.trekk),
helper AS (
SELECT spilletype, max(antall)
FROM sub
WHERE spilletype IS NOT NULL
GROUP BY spilletype)

SELECT s.spilletype, s.trekk
FROM sub s
WHERE s.antall = (
	SELECT h.antall
	FROM helper h
	WHERE h.spilletype = s.spilletype)

UNION

SELECT 'uavhenigig' AS spilltype, trekk
FROM sub
WHERE spilletype IS NULL
AND antall = (SELECT max(antall) FROM sub WHERE spilletype IS NULL);

-- Oppgave 2.6 - Populære åpninger
-- Skriv en spørring som finner det mest populære åpningstrekket (altså det vanligste
-- trekket for tur lik 1) for hver spilltype (altså 'lynsjakk', ‘hurtigsjakk’, osv.).
-- Resultatet skal også inneholde det mest populære trekket for partier som ikke
-- er tilknyttet noen turnering, og du kan da la spilltype være 'uavhengig' i resultatet.

WITH antallApninger AS (
SELECT tu.spilletype, tr.trekk, count(*) AS antall_apninger
FROM trekk tr 
JOIN parti p USING (pid)
LEFT JOIN turnering t USING (tid)
WHERE tr.tur = 1
GROUP BY tu.spilletype, tr.trekk)

SELECT aa.spilletype, aa.trekk
FROM antallApninger aa
WHERE aa.antall_apninger = (
	SELECT max(aa1.antall_apninger)
	FROM antallApninger aa1
	WHERE aa.spilletype = aa1.spilletype)
AND aa.spilletype IS NOT NULL

UNION

SELECT 'uavhengig' AS spilletype, aa.trekk
FROM antallApninger aa
WHERE aa.spilletype IS NULL
AND aa.antall_apninger = (
	SELECT max(aa1.antall_apninger) 
	FROM antallApninger aa1
	WHERE aa1.spilletype IS NULL)
























