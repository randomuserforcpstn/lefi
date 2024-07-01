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

print("Wordlist generated and saved as 'wordlist.txt'.")
