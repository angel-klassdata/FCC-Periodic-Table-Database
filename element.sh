#! /bin/bash

## Periodic Table - Element Info Script ##

# Database connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Program logic
if [[ -z $1 ]]
then
  # If no argument provided echo and exit
  echo Please provide an element as an argument.
  # exit
else
  # Check if is atomic_number, symbol, or name

  # If number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get element by atomic_number
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $1")

  # If symbol
  elif [[ $1 =~ ^[A-Z]$ ]] || [[ $1 =~ ^[A-Z][a-z]$ ]]
  then
    # get element by symbol
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$1'")
  
  # If name
  elif [[ $1 =~ [A-Z][a-z]+ ]]
  then
    # get element by name
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$1'")
  
  # edge case
  else
    echo Unhandled input case
  fi

  # Check if element exists in database
  if [[ -z $ELEMENT ]]
  then
    # not in database
    echo I could not find that element in the database.
  else
    # in database
    # *output notes: The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
    echo "$ELEMENT" | while IFS=\| read ATOMIC SYMBOL NAME MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
# exit
fi