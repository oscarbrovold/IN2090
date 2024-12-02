-- Oppgave 2.2 - Vedlikeholdt i Oslo
-- Skriv en spørring som finner alle vedlikeholdsdatoer for sensorer i Oslo sortert kronologisk.

SELECT s.vedlikeholdt
FROM sensor s
JOIN område o USING (oid)
WHERE o.navn = 'Oslo'
ORDER BY s.vedlikeholdt;

-- Oppgave 2.3 - Gjennomsnittstemperatur i Bærum
-- Skriv en spørring som finner gjennomsnittstemperaturen i Bærum når det regner
-- (nedbør er større enn 0) eller blåser mye (mer enn 5 m/s vind).

SELECT avg(s.temp) as gj_temp
FROM måling m
JOIN sensor s USING (sid)
JOIN område o USING (oid)
WHERE o.navn = 'Bærum' AND (s.nedbør > 0 OR s.vind > 5);

-- Oppgave 2.4 - Få sensorer
-- Skriv en spørring som finner navn på de tre områdene med færrest sensorer per
-- kvadratkilometer. Det kan forekomme områder uten sensorer, og disse skal også
-- med. Hint: Dersom et område har areal A og N sensorer vil det ha N/A sensorer per kvadratkilometer

SELECT o.navn, (count(s.sid) / o.areal) AS sensorer_per_areal
FROM område o
LEFT JOIN sensor s USING (sid)
GROUP BY o.oid, o.navn, o.areal
ORDER BY sensorer_per_areal
LIMIT 3;

-- Oppgave 2.5 - Analyse
-- I målingene kan det som sagt være noen NULL-verdier, og disse kan gi problemer
-- i enkelte analyser hvor dataene brukes. Skriv derfor en SQL-kommando som
-- lager et VIEW med navn analyse_vind som inneholder sid, tidspunkt og vindverdiene fra måling-tabellen, 
-- men som erstatter alle NULL-verdier i vind-kolonnen med gjennomsnittet av målingene (som ikke er NULL)
-- fra samme sensor på samme dag.

CREATE VIEW analyse_vind AS

WITH avg_vind_sid_date AS (
SELECT sid, tidspunkt::date AS dato, avg(vind) AS avg_vind
FROM måling
WHERE vind IS NOT NULL
GROUP by sid, tidspunkt::date),

nulls AS (
SELECT m.sid, m.tidspunkt, a.avg_vind
FROM måling m
JOIN avg_vind_sid_date a ON (m.tidspunkt::date = a.dato)
WHERE m.vind IS NULL),

non_nulls AS (
SELECT sid, tidspunkt, vind
FROM måling
WHERE vind IS NOT NULL)

(SELECT * FROM nulls)
UNION ALL
(SELECT * FROM non_nulls);

-- Alternativ med insperasjon fra fasit, vet forsåvidt ikke om det over fungerer.

CREATE VIEW analyse_vind AS

(SELECT sid, tidspunkt, vind
FROM måling
WHERE vind IS NOT NULL)
UNION ALL
(SELCT m.sid, m.tidspunkt, avg(o.vind)
FROM måling m JOIN måling o USING (sid)
WHERE (m.tidspunkt::date = o.tidspunkt::date)
AND m.vind IS NULL AND o.vind IS NOT NULL
GROUP BY m.sid, m.tidspunkt);

-- Oppgave 2.6 - Nedbørsmengder
-- Skriv en spørring som finner navnet på område med høyest gjennomsnittlig
-- nedbørsmengde per dag i 2023. Ta kun med områder og dager som har mer enn
-- 10 målinger. Du kan i denne oppgaven anta at alle målinger på nedbør har en
-- verdi (altså ikke er NULL). Du kan også anta at summen av alle nedbør-verdier
-- for et område for en dag er den totale nedbørsmengden for det område den
-- dagen. Hint: Du kan bruke tidspunkt::date for å hente ut datoen/dagen for en måling.

WITH sub AS (
SELECT o.oid, o.navn, m.tidspunkt::date AS dato, avg(m.nedbør) AS avg_nedbør
FROM måling m
JOIN sensor s USING (sid)
JOIN område o USING (oid)
WHERE m.tidspunkt::date >= '2023-01-01' AND m.tidspunkt::date <= '2023-12-31'
GROUP BY o.oid, o.navn, m.tidspunkt::date
HAVING count(*) > 10)

SELECT navn
FROM sub
GROUP BY oid, navn
ORDER BY avg(avg_nedbør) DESC
LIMIT 1;








