#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
MAIN_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
# get available services
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
# if no services available
  if [[ -z $AVAILABLE_SERVICES ]]
  then
      # terminate
      CONFIRM "No services available right now."
  else
# display available services
  echo -e "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
  1) APPT_MENU ;;
  2) APPT_MENU ;;
  3) APPT_MENU ;;
  *) MAIN_MENU "Please enter a valid option." ;;
esac
}

APPT_MENU() {
  # get customer phone
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  SERVICE_NAME = $($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  CUSTOMER_NAME = $($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE")
    # if does not exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new customer name
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      # insert new customer
      INSERT_CUSTOMER_RESULT = $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi
  # get customer id
  CUSTOMER_ID = $($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # get appt time
  echo -e "\nWhat time would you like to have an appointment?"
  read SERVICE_TIME   
  # book appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time VALUES('$SERVICE_ID_SELECTED','$CUSTOMER_ID','$SERVICE_TIME')")
  CONFIRM "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

CONFIRM() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
}

MAIN_MENU