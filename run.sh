#!/bin/bash

# CobaltaX Server Monitor Setup Script
# This script sets up and runs the server monitoring application
export TELEGRAM_API_ID=23097552
export TELEGRAM_API_HASH=56cfcc1b73d0cd49ea65f577f136a6d8
export TELEGRAM_CHAT_ID=-1003054181844
export TELEGRAM_DEFAULT_LIMIT=100
export TELEGRAM_REFRESH_INTERVAL=90
export COBALTAX_USER=admin
export COBALTAX_PASS='s3cret'
export COBALTAX_ADMINS=Fran
python scripts/telegram_login.py   # (once, user phone login)
python server_monitor.py

# Run the application
echo "🎯 Starting Server Monitor..."
python server_monitor.py