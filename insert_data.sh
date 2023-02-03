#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")
echo $($PSQL "TRUNCATE TABLE name_overlap RESTART IDENTITY")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    NAME=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")
    if [[ -z $NAME ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    
    NAME_OPPONENT=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    if [[ -z $NAME_OPPONENT ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

    WINNER_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_NAME=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    echo $($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR', '$ROUND', '$WINNER_GOALS', '$OPPONENT_GOALS', '$WINNER_NAME', '$OPPONENT_NAME')")
  fi
done

