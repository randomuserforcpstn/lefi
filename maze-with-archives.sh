#!/bin/bash

# Function to encode the flag in base64 and create flag.txt
encode_flag() {
    local flag="flag{Tithing_Greyhound_Bosoms} -- Username: level_X -- Password: password"
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

    mkdir -p maze

    for (( i=1; i<=$num_levels; i++ )); do
        level_name="level_$i"
        mkdir -p "maze/$level_name"
        
        for (( j=1; j<=$num_folders; j++ )); do
            folder_name="folder_$j"
            mkdir -p "maze/$level_name/$folder_name"
            
            if [[ $i -eq $num_levels && $j -eq $winner_folder ]]; then
                # This is the winner folder in the last level: place nested archives with encoded flag
                encode_flag
                create_nested_archives "flag.txt" 1

                # Determine the correct archive extension for level11
                local extension=$(archive_extension 11)
                mv "level11.$extension" "maze/$level_name/$folder_name/"
                echo "Moved level11.$extension to maze/$level_name/$folder_name/"
                return  # Exit after placing the archive in the winner folder
            fi
        done
    done
}

# Main script flow
main() {
    create_maze_structure
}

# Execute main function
main
