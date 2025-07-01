#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if an argument was passed
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

INPUT="$1"

# Determine the search field: atomic_number, symbol, or name
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  CONDITION="atomic_number = $INPUT"
elif [[ ${#INPUT} -le 2 ]]; then
  CONDITION="symbol = '$INPUT'"
else
  CONDITION="name = '$INPUT'"
fi

# Query the database
RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $CONDITION")

# Check if a result was found
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse and display the result
echo "$RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
do
  MASS_FORMATTED=$(printf "%g" $MASS)
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS_FORMATTED amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
