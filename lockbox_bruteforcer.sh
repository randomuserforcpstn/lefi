#!/bin/bash

# Define the path to your wordlist and lockbox executable
WORDLIST="wordlist.txt"
LOCKBOX="./lockbox"

# Check if the wordlist file exists
if [[ ! -f $WORDLIST ]]; then
  echo "Wordlist file $WORDLIST not found!"
  exit 1
fi

# Check if the lockbox executable exists
if [[ ! -x $LOCKBOX ]]; then
  echo "Lockbox executable $LOCKBOX not found or not executable!"
  exit 1
fi

# Variable to store the found password
found_password=""

# Iterate through each password in the wordlist
while IFS= read -r password; do
  echo "Trying password: $password"
  
  # Run the lockbox executable with the current password
  output=$($LOCKBOX "$password")
  
  # Print the output for debugging
  echo "Output: $output"
  
  # Check if the output indicates a successful unlock
  if [[ $output == *"Box unlocked!"* ]]; then
    found_password="$password"
    break
  fi
done < "$WORDLIST"

# Check if the password was found
if [[ -n $found_password ]]; then
  echo "Password found: $found_password"
else
  echo "Password not found in the wordlist."
fi

echo "Brute force attempt completed."
