#!/bin/bash

set -e

HOSTS_FILE="/etc/hosts"

echo "192.168.55.1 jetson" >> "$HOSTS_FILE"
