#!/bin/bash

# Update and install dependencies
echo "Updating package list and installing required packages..."
sudo apt-get update
sudo apt-get install -y proxychains4 curl hping3 openssl

echo "Dependencies installed successfully!"
