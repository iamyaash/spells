#! /bin/bash

echo "Creating a new content under content/posts/"
read -p "Enter the location (e.g: dirName/filename.md): "  location

echo "Creating a new content in content/posts/$location"
hugo new content content/posts/"$location"

# Insert CustomLine=2424 at 5th line
file="content/posts/$location"
tmpfile=$(mktemp)

insert_lines='params:
	author: "Yashwanth Rathakrishnan"
	ShowToc: true
	ShowReadingTime: true
	ShowCodeCopyButtons: true'

awk -v text="$insert_lines" 'NR==5{print text}1' "$file" > "$tmpfile" && mv "$tmpfile" "$file"

