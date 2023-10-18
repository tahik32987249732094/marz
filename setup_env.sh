#!/bin/bash

ENV_FILE="/marz/.env"

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  sed -i "s/\$USERNAME/$USERNAME/" "$ENV_FILE"
  sed -i "s/\$PASSWORD/$PASSWORD/" "$ENV_FILE"
else
  sed -i "/\$USERNAME/d" "$ENV_FILE"
  sed -i "/\$PASSWORD/d" "$ENV_FILE"
    if [ $? -ne 0 ]; then
    echo "username and password are not set using ENV or .env file" 
    fi
fi

if [ -n "$API_TOKEN" ] && [ -n "$ADMIN_ID" ]; then
  echo "USERNAME and PASSWORD are not set in .env file"
  sed -i "s/\$API_TOKEN/$API_TOKEN/" "$ENV_FILE"
  sed -i "s/\$ADMIN_ID/$ADMIN_ID/" "$ENV_FILE"
else
  sed -i "/\$API_TOKEN/d" "$ENV_FILE"
  sed -i "/\$ADMIN_ID/d" "$ENV_FILE"
    if [ $? -ne 0 ]; then
    echo "Telegram API token and Telegram admin ID are not set using ENV or .env file" 
    fi
fi

