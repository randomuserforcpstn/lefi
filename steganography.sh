#!/bin/bash

# Install stegsnow
if ! command -v stegsnow &> /dev/null; then
  echo "Installing stegsnow..."
  sudo apt-get update
  sudo apt-get install -y stegsnow
fi

# Generate a random HTML file with completely random content
HTML_FILE="random.html"
RANDOM_TEXT=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 1024)
echo "<!DOCTYPE html>
<html>
<head>
    <title>Random Document</title>
</head>
<body>
    <p>$RANDOM_TEXT</p>
</body>
</html>" > $HTML_FILE

# Message to hide
SECRET_MESSAGE="This is a secret message"

# Output steganography file
STEGO_FILE="stego.html"

# Use stegsnow to hide the message in the HTML file
stegsnow -C -m "$SECRET_MESSAGE" $HTML_FILE $STEGO_FILE

echo "Steganography completed. The file $STEGO_FILE contains the hidden message."
