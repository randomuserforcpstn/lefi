#!/bin/bash

# Number of random words to generate
NUM_WORDS=999
TARGET_WORD="helloworld"
WORDLIST="wordlist.txt"
WORD_LENGTH=8  # Length of each random word

# Function to generate a random word of a given length
generate_random_word() {
  local length=$1
  tr -dc 'a-zA-Z' < /dev/urandom | fold -w $length | head -n 1
}

# Generate random words and store them in an array
WORDS=()
for ((i = 0; i < NUM_WORDS; i++)); do
  WORDS+=("$(generate_random_word $WORD_LENGTH)")
done

# Add the target word to the array
WORDS+=("$TARGET_WORD")

# Shuffle the array and save to the wordlist file
shuf -e "${WORDS[@]}" > "$WORDLIST"

echo "Wordlist generated with $((NUM_WORDS + 1)) words, including '$TARGET_WORD'."
echo "Wordlist saved to $WORDLIST."
