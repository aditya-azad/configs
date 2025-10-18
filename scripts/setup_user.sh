#!/bin/bash

set -e

BASHRC_FILE="$HOME/.bashrc"

# Ask user for full name
read -p "Full Name: " FULL_NAME

# Ask user for email address
read -p "Email    : " EMAIL_ADDRESS

# Export as environment variables
echo "export USER_FULL_NAME='$FULL_NAME'" >> "$BASHRC_FILE"
echo "export USER_EMAIL_ADDRESS='$EMAIL_ADDRESS'" >> "$BASHRC_FILE"
