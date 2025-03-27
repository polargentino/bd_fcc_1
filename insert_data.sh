#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Vaciar tablas primero
$PSQL "TRUNCATE TABLE games, teams;" > /dev/null

# Función para obtener ID limpio
get_clean_id() {
  local result=$($PSQL "$1")
  echo "$result" | head -n 1 | awk '{print $1}'
}

# Procesar cada línea del archivo CSV
tail -n +2 games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Limpiar variables
  YEAR=$(echo "$YEAR" | xargs)
  ROUND=$(echo "$ROUND" | xargs | sed "s/'/''/g")
  WINNER=$(echo "$WINNER" | xargs)
  OPPONENT=$(echo "$OPPONENT" | xargs)
  WINNER_GOALS=$(echo "$WINNER_GOALS" | xargs)
  OPPONENT_GOALS=$(echo "$OPPONENT_GOALS" | xargs)

  # Insertar o obtener el equipo ganador
  WINNER_ID=$(get_clean_id "SELECT team_id FROM teams WHERE name='$WINNER';")
  if [[ -z "$WINNER_ID" ]]
  then
    WINNER_ID=$(get_clean_id "INSERT INTO teams(name) VALUES('$WINNER') RETURNING team_id;")
    echo "Insertado equipo: $WINNER (ID: $WINNER_ID)"
  fi

  # Insertar o obtener el equipo oponente
  OPPONENT_ID=$(get_clean_id "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  if [[ -z "$OPPONENT_ID" ]]
  then
    OPPONENT_ID=$(get_clean_id "INSERT INTO teams(name) VALUES('$OPPONENT') RETURNING team_id;")
    echo "Insertado equipo: $OPPONENT (ID: $OPPONENT_ID)"
  fi

  # Insertar el partido
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)" > /dev/null
  echo "Insertado partido: $YEAR $ROUND $WINNER vs $OPPONENT"
done