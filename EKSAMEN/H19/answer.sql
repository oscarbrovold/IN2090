-- Oppgave 2.2 - Band etter 2000
-- Skriv en spørring som finner alle band som enten ble startet etter år 2000 eller inneholder strengen
-- 'King' i navnet. Skriv ut navnet på bandet og datoen bandet ble startet.

SELECT b.navn
FROM band b
WHERE b.startet::date >= 2000 OR b.navn LIKE '%King%';

-- Oppgave 2.3 - Timer Pop-musikk fra 90s
-- Skriv en spørring som finner antall timer med musikk fra sjangeren 'Pop' laget av band startet
-- mellom år 1990 og 2000. Merk: En time er 3600 sekunder.

SELECT sum(s.spilletid) / 3600 AS antall_timer
FROM sjanger sj
JOIN band b USING (sjangerID)
JOIN album a USING (bandID)
JOIN sang s USING (albumID)
WHERE sj.navn = 'Pop' AND b.startet::date >= 1990 AND b.startet::date < 2000;

-- Oppgave 2.4 - Personer født på interessant dato
-- Skriv en spørring som finner navnet på alle personer født på en dato hvor det enten ble startet et
-- nytt band, eller ble gitt ut et nytt album.
