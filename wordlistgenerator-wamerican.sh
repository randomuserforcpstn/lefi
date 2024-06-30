#!/bin/bash

WORDLIST_DIR="/usr/share/dict"
WORDLIST_FILE="$WORDLIST_DIR/words"
NUM_WORDS=999
TARGET_WORD="helloworld"
WORDLIST="wordlist.txt"

# Ensure the directory exists or create it
if [[ ! -d "$WORDLIST_DIR" ]]; then
  echo "Creating directory $WORDLIST_DIR..."
  sudo mkdir -p "$WORDLIST_DIR"
fi

# Ensure the /usr/share/dict/words file exists or install the wamerican package if not
if [[ ! -f "$WORDLIST_FILE" ]]; then
  echo "Wordlist file $WORDLIST_FILE not found. Installing wamerican package..."
  sudo apt-get update
  sudo apt-get install -y wamerican
  
  # Check if installation was successful
  if [[ $? -ne 0 || ! -f "$WORDLIST_FILE" ]]; then
    echo "Failed to install wamerican package or locate $WORDLIST_FILE."
    exit 1
  fi
fi

# Generate random words and store them in an array
mapfile -t WORDS < <(shuf -n $NUM_WORDS "$WORDLIST_FILE")

# Add the target word to the array
WORDS+=("$TARGET_WORD")

# Shuffle the array and save to the wordlist file
shuf -e "${WORDS[@]}" > "$WORDLIST"

echo "Wordlist generated with $((NUM_WORDS + 1)) words, including '$TARGET_WORD'."
echo "Wordlist saved to $WORDLIST."
