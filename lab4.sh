#!/bin/sh
# Janki Jadeja 215624182

# this function outputs the files found, which are stored in tempFile

list(){
	echo "Files found: "
	cat tempFile
}

# this function removed the tempFile if it exists after exiting the script

good_exit(){
	if [ -s tempFile ]; then
		rm tempFile
		echo "goodbye"
		exit 0
	fi
	exit 0
}

# this function removes the tempFile but but the exit must have been on bad terms so it outputs 1
# considering that there is an error

bad_exit(){
	if [ -s tempFile ]; then
		rm tempFile
		exit 1
	fi
	exit 1
}

# ci function looks in the tempFile for items specified by grep and then closes the tempFile 

ci(){
	echo "Found courses are: "
	while read -r tempFile; do
		courseName=$(grep "COURSE NAME" "$tempFile" | cut -b 14-)
		credits=$(grep "CREDITS" "$tempFile" | cut -b 11-)
		echo "$courseName" "has" "$credits" "credits"
	done <tempFile
}

# sl function also looks for items specified by grep, closes the file, sorts it and then removes it

sl(){
	echo "Here is the unique list of student numbers in all courses: "
	while read -r tempFile; do
		courseName=$(grep "[0-9]\{6\}" "$tempFile" -o >>tempFile1)
	done <tempFile
	sort -u tempFile1
	rm tempFile1
}

# sc function again looks for items specified by grep, stores it in another tempFile1, sorts and counts the items

sc(){
	while read -r tempFile; do
		courseName=$(grep "[0-9]\{6\}" "$tempFile" -o >>tempFile1)
	done <tempFile
	echo "There are" "$(sort -u tempFile1 | wc -l)" "registered students in all courses"
	rm tempFile1
}

# cc function simply counts the number of course files

cc(){
	echo "There are" "$(cat tempFile | wc -l)" "course files"
}

# help function outputs the given information

help(){
	echo "List, list or l: lists found courses"
	echo "ci: gives the name of all courses plus the number of credits"
	echo "sl: gives a unique list of all students registered in all courses"
	echo "sc: gives the total number of unique students registered in all courses"
	echo "cc: gives the total number of found course files"
	echo "Help, help or h: prints the current message"
	echo "Quit, quit or q: exits from the script"
}

# Allows the user to specify a path using his/her keyboard and stores it in a variable called "path".
# If the user does not specify any path, then echo outputs that no args are passed, which returns 1 because
# 1 = there is an error, because no args are passed, this is considered as an error according to the lab requirements.

echo "Enter the path name: "							
read path									
if [ ! "$path" ]; then								
	echo "No args, run the script with an arg."				
	exit 1									
fi	

# this part checks if tempFile exists and then if it does, then it is an error

if [ -s tempFile ]; then
	echo "Please delete the file named tempFile."
	exit 1
fi

# We are looking for *.rec files in the specified path ("$path") given by the user, including in the sub-folders.
# These files must be only readable files (-perm -444). The output is redirected to tempFile.								

find "$path" -type f -name "*.rec" -perm -444 >tempFile
	
# case statement is used to output messages corresponding to the command that the user inputs
# we keep running an infinite loop using "while" until Quit, quit or q is the command chosen.
# In case the path that the user specified does not contain any *.rec readable files, that is considered as an error. 

if [ ! "$(cat tempFile | wc -l)" = 0 ]; then								
	while true; do								
		printf "command: "						
		read command							
		case $command in
			"List") list ;;
			"list") list ;;
			"l") list ;;
			"ci") ci ;;
			"sl") sl ;;
			"sc") sc ;;
			"cc") cc ;;
			"Help") help ;;
			"help") help ;;
			"h") help ;;
			"Quit") good_exit ;;
			"quit") good_exit ;;
			"q") good_exit ;;
			*) echo "Unrecognized command!" ;;
		esac	
	done
else
	echo "No readable *.rec files found."
	bad_exit
fi

# exit 1 and exit 0 is returned when the user types: echo $?
# which is simply asking the script: hey, you okay? no = 1 (error exists) and yes = 0 (no error)
