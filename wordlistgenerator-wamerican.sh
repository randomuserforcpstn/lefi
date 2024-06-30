#!/bin/bash

# Ensure the /usr/share/dict/words file exists or install the wamerican package if not
if [[ ! -f /usr/share/dict/words ]]; then
  echo "Wordlist file /usr/share/dict/words not found. Installing wamerican package..."
  sudo apt-get update
  sudo apt-get install -y wamerican
  
  # Check if installation was successful
  if [[ $? -ne 0 || ! -f /usr/share/dict/words ]]; then
    echo "Failed to install wamerican package or locate /usr/share/dict/words."
    exit 1
  fi
fi

# Number of random words to generate
NUM_WORDS=999
TARGET_WORD="helloworld"
WORDLIST="wordlist.txt"

# Generate random words and store them in an array
mapfile -t WORDS < <(shuf -n $NUM_WORDS /usr/share/dict/words)

# Add the target word to the array
WORDS+=("$TARGET_WORD")

# Shuffle the array and save to the wordlist file
shuf -e "${WORDS[@]}" > "$WORDLIST"

echo "Wordlist generated with $((NUM_WORDS + 1)) words, including '$TARGET_WORD'."
echo "Wordlist saved to $WORDLIST."
