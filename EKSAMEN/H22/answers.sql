-- Oppgave 2.2 Lynsjakk i november
-- Skriv en spørring som finner navn på alle turneringer med spilltype lynsjakk
-- som hadde startdato i november 2022 (altså fra og med 2022-11-01 og til og med 2022-11-30).

SELECT t.navn
FROM turnering t
WHERE t.spilltype = 'lynsjakk'
AND t.statdato >= '2022-11-01' AND t.startdato <= '2022-11-30';

-- Oppgave 2.3 Tenketid
-- Skriv en spørring som finner gjennomsnitlig tid brukt på alle trekk for alle partier
-- på turneringen med navn 'Oslo Open'.

SELECT avg(tk.tid_brukt)
FROM turnering tg
JOIN parti pi USING (tid)
JOIN trekk tk USING (pid)
WHERE tg.navn = 'Oslo Open';

-- Oppgave 2.4 Sjakkelakke
-- Etter at en turnering med navn 'Sjakkelakke' ble avholdt, klarte en av de
-- ansatte å legge inn en rekke partier med feil resultat, alle partiene som hadde
-- resultat 'remis' inneholder feil. Skriv derfor en SQL-kommando som sletter
-- alle rader fra parti-tabellen for partiene som har resultat 'remis' og som er
-- tilknyttet turneringen med navn 'Sjakkelakke'.

