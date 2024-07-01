#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"
SERVICES=$($PSQL "SELECT service_id, name FROM services")
# print list of services
SERVICE_LIST() {
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
echo "$SERVICES" | while read SERVICE_ID SERVICE
do
echo "$SERVICE_ID) $SERVICE" |sed 's/ |//g'
done
}
SERVICE_LIST
read SERVICE_ID_SELECTED
# if service_id not a number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then 
SERVICE_LIST "I could not find that service. What would you like today?"
else
SERVICE_ID_CHECK=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # if service_id not in the list
  if [[ -z $SERVICE_ID_CHECK ]]
  then
  SERVICE_LIST "I could not find that service. What would you like today?"
  fi
# service name  
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")  
# take customer phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
# check the customer phone number
PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# if customer phone not exsit
if [[ -z $PHONE_NUMBER ]]
then
#take customer name 
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
# add new customer
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers ( phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
else
# get customer name
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

fi
# get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#take time
echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
read  SERVICE_TIME
# add new appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")


echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


fi
