#!/bin/bash

#Colores
GREEN_C="\e[0;32m\033[1m"
END_C="\033[0m\e[0m"
RED_C="\e[0;31m\033[1m"
BLUE_C="\e[0;34m\033[1m"
YELLOW_C="\e[0;33m\033[1m"
PURPLE_C="\e[0;35m\033[1m"
TURQUOISE_C="\e[0;36m\033[1m"
GRAY_C="\e[0;37m\033[1m"

#Variables globales

#Funciones
function help_panel(){
	echo -e "\n${GRAY_C}Example:${END_C}"
	echo -e "\t${BLUE_C}bash ${END_C}${GRAY_C}subneting.sh${END_C} ${GREEN_C}-i${END_C} 192.168.1.1 ${GREEN_C}-p${END_C} 24\n"
	echo -e "Parameters:"
	echo -e "\t-i Internet protocol version 4 in the folowing fromat 123.65.3.1"
	echo -e "\t-p Network prefix (range 1-32)"
}

function ip_to_binary(){
	local ip="$1"
	local dec_to_bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
	local octeto=0
	ip_binary=""
	for octeto in $(echo $ip | tr "." " ");do
		ip_binary+=${dec_to_bin[$octeto]}"."
	done;
	ip_binary=${ip_binary[@]:0:35}
}
function binary_subnet_mask(){
	local prefix="$1"
	local bit=0
	subnet_mask_bin=""
	for ((bit=0;bit<32;bit++));do
		if [ $bit -lt $prefix ]; then
			subnet_mask_bin+="1"
			if [ $bit -eq 7 ] || [ $bit -eq 15 ] || [ $bit -eq 23 ]; then
				subnet_mask_bin+="."
			fi
		else
			subnet_mask_bin+="0"
			if [ $bit -eq 7 ] || [ $bit -eq 15 ] || [ $bit -eq 23 ]; then
				subnet_mask_bin+="."
			fi

		fi	
	done
}

function binary_to_dec(){
	local binary_subnet="$1"	
	ip_dec=""
	local byte=""
	for byte in $(echo "$binary_subnet" | tr "." " ");do
		ip_dec+="$(echo "obase=10;ibase=2; $byte" | bc)".;
	done
	ip_dec=${ip_dec[@]:0:-1}
}

function broadcast_binary(){
	local ip="$1"
	local prefix="$2"
	broadcast="$(echo $ip | tr -d ".")"
	broadcast_bin=""
	for ((bit=0;bit<32;bit++));do
		if [ $bit -lt $prefix ];then
			broadcast_bin+="${broadcast[@]:$bit:1}"
		else
			broadcast_bin+="1"
		fi
		if [ $bit -eq 7 ] || [ $bit -eq 15 ] || [ $bit -eq 23 ];then
			broadcast_bin+="."
		fi
	done
}
function min_max_hosts(){
	local ip="$1"
	local prefix="$2"
	local ip_bin="$(echo $ip | tr -d ".")"
	min_host_bin=""
	max_host_bin=""
	local bin=0
	for ((bit=0;bit<32;bit++));do
		if [ $bit -lt $prefix ];then
			min_host+="${ip_bin[@]:$bit:1}"
			max_host+="${ip_bin[@]:$bit:1}"
		else
			#min_host+="0"
			#max_host+="1"
			if [ $bit -eq 31 ];then
				min_host+="1"
				max_host+="0"
			else
			min_host+="0"
			max_host+="1"
			fi
		fi
		if [ $bit -eq 7 ] || [ $bit -eq 15 ] || [ $bit -eq 23 ];then
			min_host+="."
			max_host+="."
		fi

	done
}

while getopts "i:p:h" arg; do
	case $arg in
		i)ip_host=$OPTARG;;
		p)prefix=$OPTARG;;
		h)help_panel;;
	esac
done

echo "$ip_host" | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' &>/dev/null 
if [ $? -eq 0 ] && [ $prefix -gt 0 ] && [ $prefix -le 32 ];then

	ip_to_binary $ip_host
	binary_subnet_mask $prefix
	binary_to_dec $subnet_mask_bin
	broadcast_binary $ip_binary $prefix
	min_max_hosts $ip_binary $prefix

	echo -e "\n:Binary notation : Dot-decimal notation"| awk -F":" '{print $1"\t\t"$2"\t\t\t"$3}'
	echo -e "------------------------------------------------------------------------------"

	echo -e "\nIP: ${GREEN_C}$ip_binary${END_C} :${GREEN_C}$ip_host${END_C}" | awk -F":" '{print $1"\t\t"$2"\t\t"$3}'

	echo -e "Subnet mask: ${YELLOW_C}$subnet_mask_bin${END_C} :${YELLOW_C}$ip_dec${END_C}\n" | awk -F":" '{print $1"\t"$2"\t\t"$3}'

	binary_to_dec $broadcast_bin
	echo -e "Broadcast:${PURPLE_C}$broadcast_bin${END_C}:${PURPLE_C}$ip_dec${END_C}\n"| awk -F":" '{print$1"\t"$2"\t\t"$3}'

	binary_to_dec $min_host
	echo -e "Min. Host:${TURQUOISE_C}$min_host${END_C}:${TURQUOISE_C}$ip_dec${END_C}"| awk -F":" '{print $1"\t"$2"\t\t"$3}'

	binary_to_dec $max_host
	echo -e "Max. Host:${TURQUOISE_C}$max_host${END_C}:${TURQUOISE_C}$ip_dec${END_C}"|awk -F":" '{print $1"\t"$2"\t\t"$3}'
	echo -e "------------------------------------------------------------------------------"
	echo -e "Prefix: ${YELLOW_C}$prefix${END_C}" | awk -F":" '{print $1"\t\t"$2}'
	echo -e "Total of Hosts: ${BLUE_C}$(echo "ibase=10;2^(32-$prefix)" | bc)${END_C}"| awk -F":" '{print $1"\t"$2}'
	echo -e "Usabe hosts: ${BLUE_C}$(echo "ibase=10;2^(32-$prefix)-2" | bc)${END_C}\n"|awk -F":" '{print $1"\t"$2}'
else
	help_panel
fi

