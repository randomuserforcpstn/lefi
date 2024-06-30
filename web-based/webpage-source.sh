#!/bin/bash

# Generate random content for the HTML page
random_content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1000 | head -n 20)

# Define the flag to hide
flag="flag{Tithing_Greyhound_Bosoms} -- Username: level_X -- Password: password"

# Create the HTML file with randomized content and hidden flag
cat > index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Find the Flag</title>
</head>
<body>
    <h1>Welcome to the Challenge!</h1>
    <p>Find the flag hidden in this page's source code.</p>
    <div id="random-content">
        $random_content
    </div>
    <footer>
        <p>Good luck!</p>
    </footer>
    <!-- Hidden flag -->
    <script>
        console.log("$flag");
    </script>
</body>
</html>
EOF

echo "HTML file 'index.html' created with hidden flag."
