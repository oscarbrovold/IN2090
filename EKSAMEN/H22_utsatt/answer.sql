-- Oppgave 2.2 - Åpninger
-- Skriv en spørring som finner pid og tiden brukt på alle trekk som enten er 'e4'
-- eller 'c3' og som er på første tur (altså tur 1).

SELECT pid, tid_brukt
FROM trekk
WHERE (trekk = 'e4' OR trekk = 'c3') AND tur = 1;

-- Oppgave 2.3 - Skakk-matt vinnere
-- Skriv en SQL-spørring som finner navn på alle spillere som har vunnet med sorte
-- brikker i turneringen med navn 'Skakk-matt'. Svaret skal kun inneholde unike navn.

SELECT DISTINCT s.navn
FROM turnering t
JOIN parti p USING (tid)
JOIN spiller s ON (p.sort = s.sid)
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
SELECT 1 + (SELECT count(*) FROM spiller) AS sid, 
'Mona' AS navn,
(SELECT avg(rating)
FROM spiller s
WHERE s.sid IN (SELECT hvit FROM parti)
OR s.sid IN (SELECT sort FROM parti)) AS rating;

-- Oppgave 2.6 - Populære åpninger
-- Skriv en spørring som finner det mest populære åpningstrekket (altså det vanligste
-- trekket for tur lik 1) for hver spilltype (altså 'lynsjakk', ‘hurtigsjakk’, osv.).
-- Resultatet skal også inneholde det mest populære trekket for partier som ikke
-- er tilknyttet noen turnering, og du kan da la spilltype være 'uavhengig' i resultatet.
-- Merk: Det kan finnes flere spilltyper i databasen enn de som er listet i eksempeldataene.

WITH forste_trekk AS (
SELECT tu.spilletype, tr.trekk -- Finner første trekk for alle spilletyper, NULL der turnering ikke finnes
FROM trekk tr
JOIN parti p USING (pid)
LEFT JOIN turnering tu USING (tid)
WHERE tr.tur = 1),

uavhengige AS (
SELECT 'uavhengig' AS spilletype,
(SELECT tr.trekk FROM forste_trekk WHERE tu.spilletype IS NULL) AS trekk),

alle AS (
(SELECT * FROM forste_trekk WHERE spilletype IS NOT NULL)
UNION ALL
(SELECT * FROM uavhengig)),

counter_ob AS (
SELECT spilletype, trekk, count(*) AS counter
FROM alle
GROUP BY spilletype, trekk),

SELECT spilletype, trekk
FROM counter_ob c
WHERE c.counter = (SELECT max(counter)
	FROM counter
	WHERE spilletype = c.spilletype)


--- Alternavtivt
WITH apningstrekk AS (
(SELECT tu.spilltype, t.trekk, count(*) AS antall_apninger
FROM trekk t
JOIN parti p USING (pid)
JOIN turnering tu USING (tid)
WHERE t.tur = 1
GROUP BY tu.spilltype, t.trekk)
UNION ALL
(SELECT 'uavhengig' AS spilltype, t.trekk, count(*) AS antall_apninger
FROM trekk t
JOIN parti p USING (pid)
WHERE p.tid IS NULL AND t.tur = 1
GROUP BY trekk))

SELECT a1.spilltype, a1.trekk, a1.antall_apninger
FROM apningstrekk a1
WHERE a1.antall_apninger = (
        SELECT MAX(antall_apninger)
        FROM apningstrekk a2
        WHERE a1.spilltype = a2.spilltype);













