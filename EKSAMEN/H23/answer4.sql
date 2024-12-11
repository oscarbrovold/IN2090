-- Oppgave 2.5 - Analyse
-- I målingene kan det som sagt være noen NULL-verdier, og disse kan gi problemer
-- i enkelte analyser hvor dataene brukes. Skriv derfor en SQL-kommando som
-- lager et VIEW med navn analyse_vind som inneholder sid, tidspunkt og vindverdiene fra 
-- måling-tabellen, men som erstatter alle NULL-verdier i vind-kolonnen
-- med gjennomsnittet av målingene (som ikke er NULL) fra samme sensor på samme dag. 
-- Hint: Du kan omgjøre et timestamp til en date ved å caste den til date, altså
-- tidspunkt::date henter ut dato-verdien i tidspunkt

CREATE VIEW analyse_vind AS

WITH snitts AS (
SELECT m.sid, m.tidspunkt::date as dato, avg(m.vind) AS avg_vind
FROM måling m
GROUP BY m.sid, m.tidspunkt::date)

SELECT m.sid, m.tidspunkt, s.avg_vind
FROM måling m
JOIN snitts s ON (m.sid = s.sid AND s.dato = m.tidspunkt::date)
WHERE m.vind IS NULL

UNION

SELECT m.sid, m.tidspunkt, m.vind
FROM måling m
WHERE m.vind IS NOT NULL

-- Oppgave 2.6 - Nedbørsmengder
-- Skriv en spørring som finner navnet på område med høyest gjennomsnittlig
-- nedbørsmengde per dag i 2023. Ta kun med områder og dager som har mer enn
-- 10 målinger. Du kan i denne oppgaven anta at alle målinger på nedbør har en
-- verdi (altså ikke er NULL). Du kan også anta at summen av alle nedbør-verdier
-- for et område for en dag er den totale nedbørsmengden for det område den
-- dagen. Hint: Du kan bruke tidspunkt::date for å hente ut datoen/dagen for en måling

WITH perDag AS (
SELECT s.oid, m.tidspunkt::date AS dato, sum(m.nedbør) AS nedbør_per_dag
FROM måling m
JOIN sensor s USING (sid)
WHERE m.tidspunkt::date >= '2023-01-01' AND m.tidspunkt::date <= '2023-12-31'
GROUP BY s.oid, m.tidspunkt::date
HAVING count(m.nedbør) > 10)

SELECT o.navn
FROM perDag p
JOIN område o USING (oid)
GROUP BY p.oid, o.navn
ORDER BY avg(nedbør_per_dag) DESC
LIMIT 1;











