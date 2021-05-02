#!/bin/sh -

# Author: Beau Wong
# Class: ECE 3524
# Assignment: Project 1

# Implementation: Create a program that can output a tree of results based on directories.

# INPUT (2):
#	1: Directory to be parsed
#	2: Location of HTML output file
# OUTPUT (1):
#	1: HTML File with links to files and tree of directory space
#
# *Implementation does not take advantage of recursive functions*

if [ $# != 2 ]
then
	echo "Wrong number of inputs:" $#
	echo "You can only have 2 inputs ( Directory to be parsed,  Output file location )"
	
else
	DIRECTORY=$1
	OUTPUT_FILE=$2
	DIRECTORY_FILES=$(ls -R $1)
	echo $DIRECTORY_FILES > /home/beaucwong/ECE3524/Projects/p1/lsOut.txt
	TEST=0
	FILE_CNT=0
	DIR_CNT=0
	
	
	#check if location is a valid directory
	#	true - go in and parse
	#	false - print error
	if [ -d $DIRECTORY ]
	then
		
		#adds header to the html file
		cat  > $OUTPUT_FILE <<-SES
			<html>
			<head>
				<title>
				OUTPUT FILE
				</title>
				<center><p style="font-size:30px">TREE for $DIRECTORY</p></center>
			</head>
			<body>
		SES
		
		
	
		#get all of the directory and file names and checks if they are readable
		#	if not readable - print out to console error message
		for WORD in $DIRECTORY_FILES
		do
			#echo ${WORD::-1}
			if [ -d ${WORD::-1} ]
			then
				if [ -r ${WORD::-1} ] 
				then
					DIR_PTH[$DIR_CNT]=${WORD::-1}
					CURRDIR=${WORD::-1}
					readarray -d / -t stararr <<< "${WORD::-1}"
					DIR_NAME[$DIR_CNT]=${stararr[-1]}
					DIR_CNT=`expr $DIR_CNT + 1`
				else
					echo "Directory ${WORD::-1} is not readable"
					echo
				fi
			elif [ -f "${CURRDIR}/${WORD}" ]
			then
				if [ -r ${CURRDIR}/${WORD} ] 
				then
					#echo $WORD
					FILE_NMS[$FILE_CNT]=${WORD}
					FILE_DIR[$FILE_CNT]="${CURRDIR}/${WORD}"
					FILE_DIR_NUM[$FILE_CNT]=`expr $DIR_CNT - 1`
					FILE_CNT=`expr $FILE_CNT + 1`
				else
					echo "File ${CURRDIR}/${WORD} is not readable"
					echo
				fi
			fi
		done
		
		#checks if there are multiple directories:
		#	true - computes depth and outputs appropriatly 
		#	false - outputs appropriately
		if [ $DIR_CNT -gt 1 ]
		then
			
			#computes the depth of each directory
			for DIR in ${DIR_PTH[@]}
			do
				DIR_NUM=0
				for DIR_CHK in ${DIR_PTH[@]}
				do
					if [[ "$DIR_CHK" == *"$DIR"* ]]
					then
						if [ "$DIR" != " " -a "$DIR_CHK" != " " ]
						then 
							DIR_DPTH[DIR_NUM]=`expr ${DIR_DPTH[DIR_NUM]} + 1`
						fi
					fi
					DIR_NUM=`expr $DIR_NUM + 1`
				done 
			done

			
			#prints out directories in correct format
			DIR_NUM=0
			for DIR in ${DIR_PTH[@]}
			do
				#spacing
				for (( i=1; i<${DIR_DPTH[DIR_NUM]}; i=`expr $i + 1`))
				do	
					cat  >> $OUTPUT_FILE <<-SES
						&nbsp;
					SES
				done
				cat  >> $OUTPUT_FILE <<-SES
				&#8226; ${DIR_NAME[$DIR_NUM]} <br />
				SES
				
				FILE_NUM=0
				
				#check for files in the directory
				for FILE in ${FILE_NMS[@]}
				do
					if [ ${FILE_DIR_NUM[$FILE_NUM]} == $DIR_NUM ]
					then
						#spacing
						for (( i=1; i<${DIR_DPTH[DIR_NUM]}+1; i=`expr $i + 1`))
						do	
							cat  >> $OUTPUT_FILE <<-SES
								&nbsp; &nbsp;
							SES
						done
						cat  >> $OUTPUT_FILE <<-SES
						- <a href="${FILE_DIR[$FILE_NUM]}" target="blank"> ${FILE_NMS[$FILE_NUM]} </a> <br />
						SES
					fi
					FILE_NUM=`expr $FILE_NUM + 1`
				done
				
				DIR_NUM=`expr $DIR_NUM + 1`
			done
			
		else #only 1 directory
			
			cat  >> $OUTPUT_FILE <<-SES
				&#8226; $DIR_NAME <br />
				SES
				
				#check for files
				for FILE in ${FILE_NMS[@]}
				do
					#spacing
					for (( i=1; i<2; i=`expr $i + 1`))
					do	
						cat  >> $OUTPUT_FILE <<-SES
							&nbsp; &nbsp; &nbsp;
						SES
					done
					cat  >> $OUTPUT_FILE <<-SES
					- <a href="${FILE_DIR[$FILE_NUM]}" target="blank"> ${FILE_NMS[$FILE_NUM]} </a> <br />
					SES
					FILE_NUM=`expr $FILE_NUM + 1`
				done
		fi
		
		#adds footer to the HTML file
		cat  >> $OUTPUT_FILE <<-SES
		</body>
		</html>
		SES
		
	else #if directory in 1st argument cannot be found
		echo "Failed to parse directory" $DIRECTORY
		echo "Directory" $DIRECTORY "does not exist."
	fi
fi

