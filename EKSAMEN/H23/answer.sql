-- Skriv en spørring som finner alle vedlikeholdsdatoer for sensorer i Oslo sortert kronologisk.

SELECT s.vedlikeholdt
FROM sensor s 
INNER JOIN område o ON (s.oid = o.oid)
WHERE o.navn like 'Oslo'
ORDER BY s.vedlikeholdt;

-- Skriv en spørring som finner gjennomsnittstemperaturen i Bærum når det regner
-- (nedbør er større enn 0) eller blåser mye (mer enn 5 m/s vind).

SELECT avg(m.temp) -- Burde jeg ha 'AS gj_temp' her?
FROM område o
JOIN sensor s USING (oid)
JOIN måling m USING (sid)
WHERE o.navn LIKE 'Bærum' AND ( m.nedbør > 0 OR m.vind > 5);

-- Skriv en spørring som finner navn på de tre områdene med færrest sensorer per
-- kvadratkilometer. Det kan forekomme områder uten sensorer, og disse skal også med. 

SELECT o.navn, COUNT(s.sid)/o.areal as sensorer_per_areal
FROM område o
LEFT OUTER JOIN sensor s ON (o.oid = s.oid)
GROUP BY o.oid, o.areal, o.navn
ORDER BY sensorer_per_areal
LIMIT 3;

--I målingene kan det som sagt være noen NULL-verdier, og disse kan gi problemer
--i enkelte analyser hvor dataene brukes. Skriv derfor en SQL-kommando som
--lager et VIEW med navn analyse_vind som inneholder sid, tidspunkt og vindverdiene 
--fra måling-tabellen, men som erstatter alle NULL-verdier i vind-kolonnen
--med gjennomsnittet av målingene (som ikke er NULL) fra samme sensor på samme dag.

CREATE VIEW analyse_vind 
AS sid, tidspunkt, vind
FROM måling
WHERE vind IS NOT NULL
UNION ALL
SELECT m.sid, m.tidspunkt, avg(o.vind)
FROM måling AS m JOIN måling AS o USING (sid)
WHERE m.tidspunkt::date = o.tidspunkt::date AND
      m.vind IS NOT NULL
      o.vind IS NOT NULL
GROUP BY m.sid, m.tidspunkt;

--Skriv en spørring som finner navnet på område med høyest gjennomsnittlig
--nedbørsmengde per dag i 2023. Ta kun med områder og dager som har mer enn
--10 målinger. Du kan i denne oppgaven anta at alle målinger på nedbør har en
--verdi (altså ikke er NULL). Du kan også anta at summen av alle nedbør-verdier
--for et område for en dag er den totale nedbørsmengden for det område den
--dagen. Hint: Du kan bruke tidspunkt::date for å hente ut datoen/dagen for
--en måling

SELECT o.navn
FROM område o
JOIN sensor s USING (oid)
JOIN måling m USING (sid)

