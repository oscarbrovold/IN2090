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
JOIN sensor s ON (oid)
JOIN måling m ON (sid)
WHERE o.navn LIKE 'Bærum' AND ( m.nedbør > 0 OR m.vind > 5);
