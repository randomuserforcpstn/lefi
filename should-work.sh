#!/bin/bash

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    printf "Please run this script as root.\n" >&2
    exit 1
fi

# Global variables
USER_LIST=("level1" "level2" "level3" "level4" "level5" "level6" "level7" "vulny")
PASSWORD_LIST=("goodluck!" "F5nQ0ft23" "QWE456jh!" "5nQjh0f!" "QwTR23!lf" "Nt53lmfQ" "GTF0&inS!" "password_vulny")

# Function to create users with home directories and passwords
create_users() {
    for i in "${!USER_LIST[@]}"; do
        local user="${USER_LIST[$i]}"
        local password="${PASSWORD_LIST[$i]}"
        if id "$user" &>/dev/null; then
            printf "User %s already exists.\n" "$user"
        else
            useradd -m -s /bin/bash "$user"
            printf "%s:%s\n" "$user" "$password" | chpasswd
            printf 'cd ~\n' >> "/home/$user/.bashrc"
        fi
    done
}

# Function to install required packages
install_packages() {
    apt-get update
    apt-get install -y hashcat gcc apache2 ncat nano sudo stegsnow zip wamerican
}

# Function to setup Steganography challenge for level1
setup_steganography_challenge() {
    local HTML_FILE="/home/level1/random.html"
    local RANDOM_TEXT=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 1024)
    echo "<!DOCTYPE html>
<html>
<head>
    <title>Random Document</title>
</head>
<body>
    <p>$RANDOM_TEXT</p>
</body>
</html>" > $HTML_FILE

    local SECRET_MESSAGE="flag{Tithing_Greyhound_Bosoms} -- Username: level_2 -- Password: F5nQ0ft23"
    local STEGO_FILE="/home/level1/stego.html"

    stegsnow -C -m "$SECRET_MESSAGE" $HTML_FILE $STEGO_FILE
    chown level1:level1 $HTML_FILE $STEGO_FILE
    echo "Steganography completed. The file $STEGO_FILE contains the hidden message."
}

# Function to setup nested archive challenge for level2
setup_nested_archive_challenge() {
    local level2_home="/home/level2"

    # Function to encode the flag in base64 and create flag.txt
    encode_flag() {
        local flag="flag{Spring_Cherry_Blossoms} -- Username: level_3 -- Password: QWE456jh!"
        echo "$flag" | base64 > flag.txt
    }

    # Function to create nested archives
    create_nested_archives() {
        local file="$1"
        local level="$2"
        local max_levels=11

        if [[ $level -gt $max_levels ]]; then
            # Base case: reached maximum level, exit recursion
            return
        fi

        local archive_name="level$level"
        local next_level=$((level + 1))

        case $(( $level % 3 )) in
            0) tar -cf "$archive_name.tar" "$file" ;;
            1) gzip -c -9 "$file" > "$archive_name.gz" ;;
            2) zip -q "$archive_name.zip" "$file" ;;
        esac

        echo "Created archive: $archive_name"

        # Clean up original file after archiving
        rm "$file"

        # Recursive call to create next level
        create_nested_archives "$archive_name.$(archive_extension "$level")" "$next_level"
    }

    # Function to determine archive extension based on level
    archive_extension() {
        local level="$1"
        case $(( $level % 3 )) in
            0) echo "tar" ;;
            1) echo "gz" ;;
            2) echo "zip" ;;
        esac
    }

    # Function to create maze challenge structure
    create_maze_structure() {
        local num_folders=30
        local num_levels=10
        local winner_level=$((RANDOM % $num_levels + 1))
        local winner_folder=$((RANDOM % $num_folders + 1))

        mkdir -p $level2_home/maze

        for (( i=1; i<=$num_levels; i++ )); do
            level_name="level_$i"
            mkdir -p "$level2_home/maze/$level_name"
            
            for (( j=1; j<=$num_folders; j++ )); do
                folder_name="folder_$j"
                mkdir -p "$level2_home/maze/$level_name/$folder_name"
                
                if [[ $i -eq $num_levels && $j -eq $winner_folder ]]; then
                    # This is the winner folder in the last level: place nested archives with encoded flag
                    encode_flag
                    create_nested_archives "flag.txt" 1

                    # Determine the correct archive extension for level11
                    local extension=$(archive_extension 11)
                    mv "level11.$extension" "$level2_home/maze/$level_name/$folder_name/"
                    echo "Moved level11.$extension to maze/$level_name/$folder_name/"
                    return  # Exit after placing the archive in the winner folder
                fi
            done
        done
    }

    # Main script flow for nested archive challenge
    create_maze_structure
    chown -R level2:level2 $level2_home/maze
}

# Function to setup brute force challenge for level3
setup_brute_force_challenge() {
    local level3_home="/home/level3"

    # C script for brute force challenge
    local brute_force_script="$level3_home/lockbox.c"
    cat << 'EOF' > "$brute_force_script"
#include <stdio.h>
#include <string.h>

#define MAX_PASSWORD_LENGTH 100

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <password>\n", argv[0]);
        return 1;
    }

    char correct_password[] = "helloworld";
    char flag[] = "flag{Spooky_Sanches_Dog} -- Username: level_4 -- Password: 5nQjh0f!";
    char *password = argv[1];

    if (strcmp(password, correct_password) == 0) {
        printf("Box unlocked! Here's the flag: %s\n", flag);
    } else {
        printf("Incorrect password. Access denied.\n");
    }

    return 0;
}
EOF

    # Compile the brute force script
    gcc "$brute_force_script" -o "$level3_home/lockbox"
    rm "$brute_force_script"  # Remove the source file after compiling

    # Script to download wordlist with correct password
    snap install curl
    curl https://raw.githubusercontent.com/randomuserforcpstn/somerandomtantuniqaqash/main/wordlist.txt > /home/level3/wordlist.txt
    snap remove curl

}

# Function to setup HTML page with hidden flag for level4
setup_html_page_with_hidden_flag() {
    local level4_home="/home/level4"

    # Generate random content for the HTML page
    local random_content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1000 | head -n 20)

    # Define the flag to hide
    local flag="flag{You're_Still_Here} -- Username: level_5 -- Password: QwTR23!lf"

    # Create the HTML file with randomized content and hidden flag
    cat > "$level4_home/index.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Level 4</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .hidden-flag {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Level 4</h1>
        <p>$random_content</p>
        <p class="hidden-flag">$flag</p>
    </div>
</body>
</html>
EOF

    # Set ownership of the HTML file to level4 user
    chown level4:level4 "$level4_home/index.html"
}

# Function to setup hash-cracking task for level5
setup_hash_cracking_task() {
    local level5_home="/home/level5"

    # Function to install Hashcat
    install_hashcat() {
        apt-get update
        apt-get install -y hashcat
    }

    # Function to hash the real flag and store it in flag.txt
    hash_real_flag() {
        local real_flag="flag{It's_not_over} -- Username: level_6 -- Password: Nt53lmfQ"
        local hashed_flag=$(echo -n "$real_flag" | sha512sum | awk '{print $1}')
        echo "$hashed_flag" > "$level5_home/flag.txt"
        echo "Real flag hashed and saved in 'flag.txt'."
    }

    # Script to download wordlist with correct password
    snap install curl
    curl https://raw.githubusercontent.com/randomuserforcpstn/somerandomtantuniqaqash/main/flags.txt > /home/level5/wordlist.txt
    snap remove curl

    # Main function to setup hash-cracking task
    setup_hash_cracking() {
        generate_wordlist
        install_hashcat
        hash_real_flag
        echo "Hash-cracking setup complete."
    }
    setup_hash_cracking
}

# Function to encode flag and convert to bytecode
encode_flag_to_bytecode() {
    local flag="flag{Simple_Bytecode_Challenge} -- Username: level_7 -- Password: GTF0&inS!"
    local bytecode_file="/home/level6/.flag.bytecode"

    # Encode flag to base64 and convert to bytecode
    echo -n "$flag" | base64 | xxd -p > "$bytecode_file"

    echo "Bytecode conversion complete. Bytecode stored in '$bytecode_file'."
}

# Main function to setup bytecode analysis task
setup_bytecode_analysis() {
    encode_flag_to_bytecode
}

# Function to setup Level 7 with sudo permissions
setup_level7_sudo_privilege() {
    local level7_home="/home/vulny"
    
# Add the sudoers rule for vulny to run nano without a password
    echo "vulny ALL=(ALL) NOPASSWD: /bin/nano" > /etc/sudoers.d/vulny
    echo "level7 ALL=(vulny) NOPASSWD: /bin/nano" > /etc/sudoers.d/level7
    su - level7 -c "sudo -u vulny nano"

    # Hide the flag in the level7_home directory
    local flag="flag{Ultimate_Privilege_Escalation} -- Username: root -- Password: Y0u_4re_r00t!"
    echo "$flag" > "$level7_home/flag.txt"
    chown vulny:vulny "$level7_home/flag.txt"
    echo "root:Y0u_4re_r00t!" | chpasswd
}

root_flag_creation(){
    # Create the flag file with the desired content
    echo "flag{We_Hope_You_Enjoyed}" > /root/.megasecret

    # Ensure the file is only accessible by the root user
    chmod 600 /root/.megasecret
    echo "Flag file created at /root/.megasecret"
}


# Main script execution
create_users
install_packages
setup_steganography_challenge
setup_nested_archive_challenge
setup_brute_force_challenge
setup_html_page_with_hidden_flag
setup_hash_cracking_task
setup_bytecode_analysis
setup_level7_sudo_privilege
root_flag_creation

printf "Setup complete.\n"
