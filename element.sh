#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
  then
    if [[ $1 =~ ^[0-9]+$ ]]
      then
        ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = '$1';")
      else
        ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1';")
    fi
    if [ -z $ELEMENT ]
      then
        echo "I could not find that element in the database."
      else
        echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
          do   
            PROPERTIE=$($PSQL "SELECT * FROM properties WHERE atomic_number = '$ATOMIC_NUMBER';")
            echo $PROPERTIE | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MPC BPC TYPE_ID
              do
                TYPE=$($PSQL "SELECT type FROM types WHERE type_id = '$TYPE_ID';")
                echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
              done
          done    
    fi
  else
    echo "Please provide an element as an argument."
fi