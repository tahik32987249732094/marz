#!/bin/bash

source /marz/.shell_env
ENV_FILE=/marz/.env

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
    echo "SUDO_USERNAME = $USERNAME" >> $ENV_FILE
    echo "SUDO_PASSWORD = $PASSWORD" >> $ENV_FILE
fi
if [ -n "$API_TOKEN" ] && [ -n "$ADMIN_ID" ]; then
    echo "TELEGRAM_API_TOKEN = $API_TOKEN" >> $ENV_FILE
    echo "TELEGRAM_ADMIN_ID = $ADMIN_ID" >> $ENV_FILE
fi
