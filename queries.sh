#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

echo -e "\nTotal de goles en todos los partidos de los equipos ganadores:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

echo -e "\nTotal de goles en todos los partidos de los equipos perdedores:"
echo "$($PSQL "SELECT SUM(opponent_goals) FROM games;")"

echo -e "\nPromedio de goles en todos los partidos de los equipos ganadores:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games;")"

echo -e "\nPromedio de goles en todos los partidos de los equipos perdedores:"
echo "$($PSQL "SELECT AVG(opponent_goals) FROM games;")"

echo -e "\nMayor número de goles marcados en un solo partido por un equipo:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games;")"

echo -e "\nNúmero de partidos donde el equipo ganador marcó más de dos goles:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2;")"

echo -e "\nEquipo ganador del torneo de 2018:"
echo "$($PSQL "SELECT name FROM teams JOIN games ON teams.team_id = games.winner_id WHERE games.year = 2018 AND games.round = 'Final';")"

echo -e "\nLista de equipos que jugaron en la ronda 'Final' de 2014:"
echo "$($PSQL "SELECT name FROM teams JOIN games ON teams.team_id = games.winner_id OR teams.team_id = games.opponent_id WHERE games.year = 2014 AND games.round = 'Final';")"

echo -e "\nLista de nombres de equipos únicos con al menos un partido en la ronda 'Final', ordenados alfabéticamente:"
echo "$($PSQL "SELECT DISTINCT name FROM teams JOIN games ON teams.team_id = games.winner_id OR teams.team_id = games.opponent_id WHERE games.round = 'Final' ORDER BY name;")"

echo -e "\nAño y nombre del equipo de todos los campeones:"
echo "$($PSQL "SELECT year, name FROM games JOIN teams ON games.winner_id = teams.team_id WHERE round = 'Final' ORDER BY year;")"

echo -e "\nLista de equipos que comienzan con 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%';")"