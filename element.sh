#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_INPUT=$1

if [[ -z $ELEMENT_INPUT ]]
  then
    echo "Please provide an element as an argument."
    exit
  fi

ELEMENT_DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE '$ELEMENT_INPUT' = atomic_number::TEXT OR '$ELEMENT_INPUT' = symbol OR '$ELEMENT_INPUT' = name")
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT_DATA" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
