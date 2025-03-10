#!/bin/bash

# Make sure you have setup SSH keys within runpod for the below to work
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh/authorized_keys
service ssh start

DIRECTORY="wordlists"

# Loop through all .7z files in the directory
for file in "$DIRECTORY"/*.7z; do
  # Check if there are any .7z files
  [ -e "$file" ] || continue

  echo "Extracting: $file" 
  
  # Extract the .7z file to a folder with the same name (without extension)
  7zz x "$file" -o"$DIRECTORY"

  echo "Done: $file"
  rm "$file" 
done

DIRECTORY="rules"

# Loop through all .7z files in the directory
for file in "$DIRECTORY"/*.7z; do
  # Check if there are any .7z files
  [ -e "$file" ] || continue

  echo "Extracting: $file" 
  
  # Extract the .7z file to a folder with the same name (without extension)
  7zz x "$file" 

  echo "Done: $file" -o"$DIRECTORY"
  rm "$file"
done

sleep infinity # Needed to keep container open