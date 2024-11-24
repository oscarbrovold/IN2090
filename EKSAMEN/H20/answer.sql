-- Oppgave 2 - Italiensk værmelding
-- Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for
-- alle byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter
-- regn og vindstyrken. Sorter resultatet alfabetisk på bynavn.

SELECT b.navn, v.nedbør, v.vind
FROM værmelding v
JOIN by b USING (bid)
JOIN land l USING (lid)
WHERE l.lid = 'Italia' AND v.dato = '2020-12-17'
ORDER BY b.navn;


-- Oppgave 3 - Ukesmelding
-- Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
-- gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til og
-- med dato 31.12.2020) for hver by.

SELECT b.navn, sum(v.nedbør) AS sum_nedbør, avg(v.vind) AS avg_vind
FROM værmelding v
JOIN by b USING (bid)
WHERE (v.data <= '2020-12-31' AND v.dato >= '2020-12-24')
GROUP BY b.bid, b.navn;

-- Oppgave 4 - Byer uten regn
-- Skriv en SQL-spørring som finner navn på alle byer hvor det ikke er meldt noe
-- regn og ikke noe vind fra og med julaften (24.12.2020) og ut året. Spørringen
-- skal skrive ut navnet på byene. Du kan anta at vi har værmelding (og både
-- nedbør og vindstyrke) for alle byer hver dag i julen. 

SELECT b.navn
FROM værmelding v
JOIN by b USING (bid)
WHERE v.dato < '2021-01-01' AND v.dato >= '2020-12-24'
GROUP BY b.bid, b.navn
HAVING sum(v.vind) = 0 AND sum(v.nedbør) = 0;

-- Oppagve 5 - Steder og vær
-- Skriv en SQL-kommando som lager et VIEW med navn Steder som viser dagens
-- værmelding (nedbør i mm. og vindstyrke) for både byer og POIs i samme tabell.
-- Du kan anta at dagens dato finnes i variabelen current_date (slik som i PostgreSQL). VIEWet skal ha 4 kolonner, en med navnet på stedet, en med plassering
-- som er landet dersom stedet er en by og adressen dersom stedet er en POI, samt
-- nedbør og vindstyrke. For POIs er nedbør og vindstyrke lik byen den befinner
-- seg i sin nedbør og vindstyrke. Vi er kun interessert i steder som faktisk har en
-- posisjon, altså skal posisjon aldri være NULL.

CREATE VIEW steder_vær AS
(SELECT b.navn, l.navn AS posisjon, v.nedbør, v.vind
FROM værmelding v
JOIN by b USING (bid)
JOIN land l USING (lid)
WHERE v.dato = current_date)
UNION
(SELECT p.navn, p.adresse AS posisjon, v.nedbør, v.vind
FROM værmelding v 
JOIN poi p USING (bid)
WHERE v.dato = current_date AND p.adresse IS NOT NULL)

-- Oppgave 6 - Ferieplanlegging
-- La oss si at du skal reise på ferie til Frankrike og ønsker å finne ut hvilken by
-- du skal reise til for å gå tur og se på museer. Skriv derfor en SQL-spørring som
-- finner den byen i Frankrike med opphold (0 mm. nedbør) i morgen (17.12.2020),
-- som har minst 3 kaféer og som har flest museer.

WITH byer_uten_nedbør_imorgen AS (
SELECT bid
FROM værmelding v
JOIN by b USING (bid)
JOIN land l USING (lid)
WHERE v.nedbør = 0 
AND v.dato = '2020-12-17'
AND l.navn = 'Frankrike'),

byer_med_minst_tre_kafeer AS (
SELECT bid 
FROM poi p
WHERE p.type = 'kafé' 
GROUP BY p.bid
HAVING count(*) >= 3),

antall_museer_per_by AS (
SELECT bid, count(*) as antall_museer
FROM poi p
WHERE p.type = 'museum'
GROUP BY p.bid
ORDER antall_museer)

SELECT b.navn
FROM byer_uten_nedbør_imorgen n
JOIN byer_med_minst_tre_kafeer k USING (bid)
JOIN antall_museer_per_by m USING (bid)
JOIN by b USING (bid)
ORDER BY m.antall_museer DESC
LIMIT 1;











