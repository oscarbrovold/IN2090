-- Oppgave 5 - Snille barn
-- Skriv en SQL-kommando som oppdaterer barnet med bid lik 0 sin snill-verdi til false.

UPDATE barn 
SET snill = false
WHERE bid = 0;

-- Oppgave 6 - Nyttige gaver
-- Skriv en spørring som finner alle barn som ønsker seg nyttige gaver som har
-- navn som starter med strengen 'Sokker'. Spørringen skal returnere navnet på
-- barnet og navnet på gaven.

SELECT b.navn, g.navn
FROM ønskeliste ø, barn b, gave g
WHERE (ø.barn = b.bid) 
AND (ø.gave = g.gid) 
AND g.navn LIKE 'Sokker%'
AND g.nyttig;

-- Usikker om det funker, alternativt
SELECT b.navn, g.navn
FROM barn b
JOIN ønskeliste ø ON (b.bid = ø.barn)
JOIN gave g ON (g.gid = ø.gave)
WHERE g.navn LIKE 'Sokker%' AND g.nyttig;

-- Oppgave 7 - Oversikts-VIEW
-- Skriv en SQL-kommando som lager et VIEW som heter oversikt og inneholder
-- én rad for hvert ønske med bid og navnet på barnet som har ønsket, gid og
-- navnet på gaven som er ønsket, hvorvidt barnet har vært snill, og hvorvidt gaven
-- er nyttig. VIEWet skal være sortert først på barnets navn, og så på gavens navn i
-- alfabetisk rekkefølge.

CREATE VIEW oversikt AS (
SELECT b.bid, b.navn AS barn, g.gid, g.navn AS gave, b.snill, g.nyttig
FROM barn b
JOIN ønskeliste ø ON (b.bid = ø.barn)
JOIN gave g ON (g.gid = ø.gave)
ORDER BY barn, gave);

-- Oppgave 8 - Like ønsker
-- Skriv en SQL-spørring som finner alle par av ulike barn som har ønsket seg
-- det samme. Svaret skal kun inneholde unike rader. Du kan benytte VIEWet fra
-- oppgave 7 om du ønsker.

SELECT DISTINCT o1.barn, o2.barn
FROM oversikt o1
JOIN oversikt o2 USING (gid)
WHERE o1.bid != o2.bid;







