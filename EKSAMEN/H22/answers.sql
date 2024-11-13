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

DELETE 
FROM parti p
WHERE p.tid = (SELECT t.tid FROM turnering t WHERE t.navn = 'Sjakkelakke')
AND p.vinner = 'remis';

-- Oppgave 2.5 Resultater
-- Skriv en SQL-kommando som lager et VIEW med navn resultat som inneholder
-- resultater av partier for hver spiller. Det skal inneholde tre kolonner: pid for
-- partiet, sid for spilleren, og en kolonne med navn utfall som enten er 'vant',
-- 'tapte' eller 'remis' avhengig av om spilleren henholdsvis vant partiet, tapte
-- partiet, eller partiet ble remis/uavgjort.

CREATE VIEW resultat(pid, sid, utfall) AS
SELECT pid, hvit, 'vant'
FROM parti 
WHERE vinner = 'hvit'
UNION
SELECT pid, sort, 'vant'
FROM parti
WHERE vinner = 'sort'
UNION 
SELECT pid, hvit 'tapte'
FROM parti 
WHERE vinner = 'sort'
...

-- Oppgave 2.6 Vinnere
-- I sjakkturneringene får man 1 poeng hver gang man vinner et parti og 0 poeng
-- om man taper. Dersom et parti ender med remis (uavgjort) vil hver spiller få
-- 0.5 poeng hver. Vinneren av turneringen er den med flest poeng. Dersom det er
-- uavgjort legges det til ekstra partier for de med flest poeng, slik at det alltid
-- ender med at én har flest poeng i hver turnering.
-- Skriv en spørring som finner vinneren på hver turnering. Spørringen skal
-- returnere navn på turneringen og navnet på spilleren som vant turneringen. Du
-- kan bruke viewet fra forrige oppgave om du ønsker.

SELECT *
FROM turnering t 
JOIN parti p USING (tid)
JOIN resultat USING (pid)
JOIN spiller s USING (sid)
GROUP BY t.tid, t.navn




