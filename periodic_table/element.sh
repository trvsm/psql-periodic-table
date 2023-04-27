#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9] ]]
  then
    TARGET_ELEMENT=$($PSQL "SELECT * FROM elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id WHERE elements.atomic_number=$1")
  else
    TARGET_ELEMENT=$($PSQL "SELECT * FROM elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id WHERE symbol='$1' or name='$1'")
  fi

  if [[ -z $TARGET_ELEMENT ]]
  then
  echo "I could not find that element in the database."
  else
    echo $TARGET_ELEMENT | while IFS="|" read NUMBER SYMBOL NAME N2 AT_MASS MP BP T_ID T_ID2 TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  fi
fi