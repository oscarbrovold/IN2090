-- Oppgave 2.2 - Vedlikehold i Oslo
-- Skriv en spørring som finner alle vedlikeholdsdatoer for sensorer i Oslo sortert kronologisk.

SELECT s.vedlikeholdt
FROM sensor s
JOIN område o USING (oid)
WHERE o.navn = 'Oslo'
ORDER BY s.vedlikeholdt;


-- Oppgave 2.3 - Gjennomsnittstemperatur i Bærum
-- Skriv en spørring som finner gjennomsnittstemperaturen i Bærum når det regner
-- (nedbør er større enn 0) eller blåser mye (mer enn 5 m/s vind).

SELECT avg(m.temp)
FROM måling m
JOIN sensor s USING (sid) JOIN område o USING (oid)
WHERE o.navn = 'Bærum' AND (m.nedbør > 0 OR m.vind > 5);

-- Oppgave 2.4 - Få sensorer
-- Skriv en spørring som finner navn på de tre områdene med færrest sensorer per
-- kvadratkilometer. Det kan forekomme områder uten sensorer, og disse skal også
-- med. Hint: Dersom et område har areal A og N sensorer vil det ha N/A sensorer per kvadratkilometer

SELECT o.navn, (count(sid) / o.areal) AS sens_per_kvad
FROM område o
LEFT JOIN sensor s USING (oid)
GROUP BY o.oid, o.navn, o.areal
ORDER BY sens_per_kvad
LIMIT 3;

-- Oppgave 2.5 Analyse
-- I målingene kan det som sagt være noen NULL-verdier, og disse kan gi problemer
-- i enkelte analyser hvor dataene brukes. Skriv derfor en SQL-kommando som
-- lager et VIEW med navn analyse_vind som inneholder sid, tidspunkt og vindverdiene fra måling-tabellen,
-- men som erstatter alle NULL-verdier i vind-kolonnen med gjennomsnittet av målingene (som ikke er NULL) 
-- fra samme sensor på samme dag.

CREATE VIEW analyse_vind AS 

WITH avg_sensor_dag AS (
SELECT m.sid, m.tidspunkt::date AS dato, avg(vind) as avg_vind
FROM måling m
GROUP BY m.sid, m.tidspunkt::date)

(SELECT sid, tidspunkt, vind
FROM måling
WHERE vind IS NOT NULL)
UNION ALL
(SELECT m.sid, m.tidspunkt, a.avg_vind
FROM måling m
JOIN avg_sensor_dag a USING (sid)
WHERE a.dato = m.tidspunkt::date
AND m.vind IS NULL)


