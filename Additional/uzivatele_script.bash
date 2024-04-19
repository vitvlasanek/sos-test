#!/bin/bash

userPass=$1;
size=${#userPass}
for i in $(seq 0 99);
do 
	echo $userPass;
	echo $size;
	if (($size == 0 )); then
		echo "Heslo nezadano, bude prirazeno prazdne";
		userPass="pppppp";
	elif (( $size < 6 )); then
		echo "Heslo prilis kratke";
		exit 1;	
	fi;
	useradd -m -s /bin/bash -c "ucet$i" -p `echo $userPass | openssl passwd -1 -stdin` ucetT$i;
	setquota -u ucet$i 10 20 5 10 -a /home/raid;
	if (($size == 0 )); then
		passwd -d ucetT$i;
	fi;

done;
