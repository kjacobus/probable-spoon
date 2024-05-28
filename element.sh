#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU() {

if [[ -z $1 ]]
then
 echo "Please provide an element as an argument."
else
 #check if arg is a symbol
 IS_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1';")
 if [[ -n $IS_SYMBOL ]]
 then
 #find details
 
 
 PRINT_DETAILS $1 "symbol"
 else
 #check if arg is a name
  IS_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1';")

  if [[ -n $IS_NAME ]]
  then
  
  
  PRINT_DETAILS $1 "name"
  #find details
  else
  #check if arg is a number at all:
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  NOT_FOUND
  fi
  #check if arg is a atomic number
  IS_NUMBER=($PSQL "SELECT atomic_number from elements where atomic_number='$1';")
  if [[ -n $IS_NUMBER ]]
  then
  
  PRINT_DETAILS $1 "atomic_number"
  #find details
  else
   NOT_FOUND
  fi
  fi
 fi

fi
}

PRINT_DETAILS() {

GET_ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements join properties using (atomic_number) join types using(type_id) where $2='$1';")

echo $GET_ELEMENT_INFO | while IFS='|' read A_NUM A_SYM A_NAME A_MASS MPC BPC  A_TYPE
do
echo "The element with atomic number $A_NUM is $A_NAME ($A_SYM). It's a $A_TYPE, with a mass of $A_MASS amu. $A_NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
done
}

NOT_FOUND() {
  echo "I could not find that element in the database."
  exit
}

MAIN_MENU $1