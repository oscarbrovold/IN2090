-- Oppgave 2a
SELECT p.navn
FROM planet p
WHERE p.stjerne LIKE 'Proxima Centauri';

-- Oppgave 2b
SELECT DISTINCT oppdaget
FROM planet
WHERE stjerne LIKE 'TRAPPIST-1' OR navn LIKE 'Kepler-154';

-- Oppgave 2c
SELECT count(*)
FROM planet
WHERE masse IS NULL;

-- Oppgave 2d
SELECT navn, masse
FROM planet
WHERE oppdaget = 2020
      AND masse > (
      SELECT avg(masse)
      FROM planet
);

-- Oppgave 2e
SELECT (max(oppdaget) -  min(oppdaget))
FROM planet;

-- Oppgave 3a
SELECT p.navn
FROM planet p INNER JOIN materie m ON (p.navn = m.planet)
WHERE p.masse > 3 AND p.masse < 10 AND m.molekyl LIKE 'H2O';

-- Oppgave 3b
SELECT p.navn
FROM planet p
INNER JOIN stjerne s ON (p.stjerne = s.navn)
INNER JOIN materie m ON (m.planet = p.navn)
WHERE s.avstand < (12 * s.masse) AND m.molekyl LIKE 'H';

-- Oppgave 3c
SELECT p1.navn AS planet1, p2.navn AS planet2, s.navn AS stjerne
FROM planet p1
JOIN planet p2 ON p1.stjerne = p2.stjerne AND p1.navn < p2.navn
JOIN stjerne s ON p1.stjerne = s.navn
WHERE s.avstand < 50
AND p1.masse > 10
AND p2.masse > 10;

-- Oppgave 4
-- Nils, riktig spørring er:
SELECT p.oppdaget
FROM planet p JOIN stjerne s ON (p.stjerne = s.navn)
WHERE avstand > 8000;

-- Oppgave 5a
INSERT INTO stjerne
VALUES ('Sola', 0, 1);

-- Oppgave 5b
INSERT INTO planet
VALUES ('Jorda', 0.003146, NULL, 'Sola');

-- Oppgave 6
CREATE TABLE observasjon (
observasjons_id int PRIMARY KEY,
observasjons_dato timestamp NOT NULL,
planet text REFERENCES planet(navn),
kommentar text
);
