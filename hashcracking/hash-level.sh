#!/bin/bash

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    printf "Please run this script as root.\n" >&2
    exit 1
fi

# Function to install Hashcat
install_hashcat() {
    apt-get update
    apt-get install -y hashcat
}

# Function to hash the real flag and store it in flag.txt
hash_real_flag() {
    real_flag="flag{It's_not_over} -- Username: level_6 -- Password: Nt53lmfQ"
    hashed_flag=$(echo -n "$real_flag" | sha512sum | awk '{print $1}')
    echo "$hashed_flag" > flag.txt
    echo "Real flag hashed and saved in 'flag.txt'."
}

# Function to generate wordlist using Python script
generate_wordlist() {
    python3 - <<EOF
import random
import string

# Function to generate random password
def generate_random_password():
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(random.randint(8, 16)))

# Function to generate random flag with three words separated by underscores
def generate_random_flag():
    words = ['Apple', 'Banana', 'Cherry', 'Dolphin', 'Elephant', 'Falcon', 'Giraffe', 'Hippo', 'Iguana', 'Jaguar']
    return '_'.join(random.sample(words, 3))

# Generate 2000 lines with random flag names and passwords
lines = []
for _ in range(2000):
    flag = generate_random_flag()
    password = generate_random_password()
    line = f"flag{{{flag}}} -- Username: level_6 -- Password: {password}"
    lines.append(line)

# Write lines to wordlist.txt file
with open('wordlist.txt', 'w') as f:
    for line in lines:
        f.write(line + '\n')

# Append real flag to wordlist.txt
real_flag = "flag{It's_not_over} -- Username: level_6 -- Password: Nt53lmfQ"
with open('wordlist.txt', 'a') as f:
    f.write(real_flag + '\n')

print("Wordlist generated and saved as 'wordlist.txt.'")
EOF
}

# Main function to setup hash-cracking task
main() {
    generate_wordlist
    install_hashcat
    hash_real_flag
    echo "Hash-cracking setup complete."
}

main "$@"
