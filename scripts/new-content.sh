#! /bin/bash

echo "Creating a new content under content/posts/"
read -p "Enter the location (e.g: dirName/filename.md): "  location

echo "Creating a new content in content/posts/$location"
hugo new content content/posts/"$location"
