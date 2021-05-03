#!/bin/sh -

# Author: Beau Wong
# Class: ECE 3524
# Assignment: Project 3

# Implementation: Create a recursive shell script that can handle the following operations:
# 1 - Shows operating system information
# 2 - Shows Hostname and DNS information
# 3 - Show Network Information
# 4 - Shows who is currently online
# 5 - Shows a list of users that were most recently logged in in reverse chronological order
# 6 - Shows the Public IP Address
# 7 - Shows current Disk Usage
# 8 - Creates a file tree html file based on the /home directory
# 9 - Preform operations on processes (OPTIONAL)

# INPUT (1):
#	1: Command to be preformed [ 1 - 10 ]
#
# OUTPUT (1):
#	1: Necessary text for each command
#
# *Implementation does not implement #9*
# *Implementation has support for invalid inputs*


RUNNING=1

while [ $RUNNING -eq 1 ]
do
	#MAIN MENU
	clear
	date
	echo "------------------------------------------------------"
	echo "  Main Menu  "
	echo "------------------------------------------------------"
	echo "1. Operating System Info"
	echo "2. Hostname and DNS info"
	echo "3. Network info"
	echo "4. Who is online"
	echo "5. Last logged in users"
	echo "6. My IP address"
	echo "7. My disk usage"
	echo "8. My home file-tree"
	echo "9. Process operations"
	echo "10. Exit"
	
	read -p "Enter your choice [ 1 - 10 ] " USER_INPUT
	
	#No Input
	if [ ${#USER_INPUT} -eq 0 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  ...Oops  "
		echo "------------------------------------------------------"
		echo
		echo "No input received"
		echo
		read -p "press [Enter] to continue" USER_INPUT
		
	#SYSTEM INFORMATION
	elif [ $USER_INPUT -eq 1 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  System Information  "
		echo "------------------------------------------------------"
		echo "Operating system :" $(cat /etc/*-release | awk 'NR==1{print $1}')
		lsb_release -a | awk 'NR>1'
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#HOSTNAME AND DNS INFORMATION
	elif [ $USER_INPUT -eq 2 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  Hostname and DNS information  "
		echo "------------------------------------------------------"
		echo "Hostname: " $(hostname)
		echo "DNS Domain Name: " $(hostname -d)
		echo "Fully qualified domain name : " $(hostname -f)
		echo "Network address (IP) : " $(hostname -I | awk '{print $NF}')
		echo "DNS name servers (DNS IP) : " $(grep "nameserver" /etc/resolv.conf | awk '{print $NF}')
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#NETWORK INFORMATION
	elif [ $USER_INPUT -eq 3 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  Network information  "
		echo "------------------------------------------------------"
		echo "Total network interfaces found :" $(ls -A /sys/class/net | wc -l)
		echo "*** IP Addresses Information ***"
		ifconfig -a
		echo "------------------------------------------------------"
		echo "  Network routing  "
		echo "------------------------------------------------------"
		route
		echo "------------------------------------------------------"
		echo "  Interface traffic information  "
		echo "------------------------------------------------------"
		netstat -i
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#WHO IS ONLINE
	elif [ $USER_INPUT -eq 4 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  Who is online  "
		echo "------------------------------------------------------"
		who -H
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#LIST OF LAST LOGGED IN USERS
	elif [ $USER_INPUT -eq 5 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  List of last logged in users (15)  "
		echo "------------------------------------------------------"
		last | awk 'NR<16'
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#PUBLIC IP ADDRESS
	elif [ $USER_INPUT -eq 6 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  Public IP information  "
		echo "------------------------------------------------------"
		dig +short myip.opendns.com @resolver1.opendns.com
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#DISK USAGE
	elif [ $USER_INPUT -eq 7 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  Disk Usage Info "
		echo "------------------------------------------------------"
		df -h | awk '{print $5, $1}'
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#FILETREE FROM PROJ1
	elif [ $USER_INPUT -eq 8 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  /home Filetree "
		echo "------------------------------------------------------"
		echo "*** Proj1 output ***"
		bash proj1.sh /home filetree.html
		echo "***Finished: tree in \"filetree.html\"***"
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#PROCESS MANAGEMENT (NOT IMPLEMENTED)
	elif [ $USER_INPUT -eq 9 ]
	then
		clear
		echo "------------------------------------------------------"
		echo "  ...Oops  "
		echo "------------------------------------------------------"
		echo
		echo "This function was not implemented"
		echo
		read -p "Press [Enter] to continue" USER_INPUT
		
	#EXIT
	elif [ $USER_INPUT -eq 10 ]
	then
		RUNNING=0
		clear
		echo "Thank you, have a wonderful day!"
		
	#INVALID INPUT
	else
		clear
		echo "------------------------------------------------------"
		echo "  Process operations  "
		echo "------------------------------------------------------"
		echo
		echo "Invalid Input: " $USER_INPUT
		echo
		read -p "Press [Enter] to continue" USER_INPUT
	
	fi

done


