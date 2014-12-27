#! /bin/sh
# @(#) xcal.sh ver.1.1  2014.12.27  (c)Takeru.
#
# Usage:
#      xcal.sh [-m month [year]]
#      xcal.sh [-3|+3]
#
# Description:
#      The xcal utility displays a simple calendar.
#      If auguments are not specified, the current month is displayed.
#
#      -m      Display the specified month.
#      -3      Display prev/current/next month output.
#      +3      Display current/next/after next month output.
#
#      Copyright (c) 2014 Takeru.
#      Released under the MIT license
#      http://opensource.org/licenses/MIT
#
#############################################################
set -o nounset                              # Treat unset variables as an error
declare -a get_date=(`date '+%Y %m'`)
curr_y=${get_date[0]}
curr_m=${get_date[1]}
diff_m=0
diff_y=0
if test "${curr_m:0:1}" == "0"; then
	curr_m=${curr_m:1:1}
fi
case $# in
	0)		opt=1;;
	1)		opt=3
			if test "$1" == "-3"; then
				diff_m=-1
			elif test "$1" == "+3"; then
				diff_m=0
			else
				echo $0: illegal option $1
				exit 1
			fi;;
	2|3)	opt=1
			diff_y=$((${3-${curr_y}} - ${curr_y}))
			if test "$1" == "-m" -a $2 -ge 1 -a $2 -le 12; then
				diff_m=$(($2 - ${curr_m}))
			else
				echo $0: illegal option $1
				exit 1
			fi;;
	*)		echo $0: illegal option; exit 1;;
esac
function mkcal() {
	if test $diff_y -lt -112; then
		echo $0: cannot calculate...
		exit 1
	fi
	if test "${diff_m:0:1}" != "-" -a "${diff_m:0:1}" != "+"; then
		diff_m="+"$diff_m
	fi
	if test "${diff_y:0:1}" != "-" -a "${diff_y:0:1}" != "+"; then
		diff_y="+"$diff_y
	fi
	declare -a get_date=(`date -v${diff_m}m -v${diff_y}y '+%Y %m %B %e'`)
	curr_y=${get_date[0]}
	curr_m=${get_date[1]}
	curr_B=${get_date[2]}
	curr_d=${get_date[3]}
	start_o=`date -v${diff_m}m -v${diff_y}y -v-$(($curr_d - 1))d '+%w'`
	declare -a EOM=(0 31 28 31 30 31 30 31 31 30 31 30 31)
	if test $((curr_y % 4)) -eq 0 -a $((curr_y % 100)) -ne 0 -o $((curr_y % 400)) -eq 0; then
		EOM[2]=$((EOM[2]+1))
	fi
	if test "${curr_m:0:1}" == "0"; then
		curr_m=${curr_m:1:1}
	fi
	if test "$LANG" == "ja_JP.UTF-8"; then
		EOM[0]=1
		week=$curr_m"月"
		declare -a cal_seq=(日 月 火 水 木 金 土)
	else
		week=$curr_B
		declare -a cal_seq=(Su Mo Tu We Th Fr Sa)
	fi
	if test $opt -eq 1; then
		week=${week}"_"$curr_y
	fi
	if test $start_o -ne 0; then
		for i in `seq 1 $start_o`; do
			cal_seq=(${cal_seq[*]} "__")
		done
	fi
	declare -a curr_cal=()
	for i in `seq 1 ${EOM[$curr_m]}`; do
		curr_cal[$i]=$i
		if test $i -lt 10; then
			curr_cal[$i]="_"${curr_cal[$i]}
		fi
		if test $i -eq $curr_d -a "$diff_m" == "+0" -a "$diff_y" == "+0"; then
			curr_cal[$i]="\033[47m"${curr_cal[$i]}"\033[0m"
		fi
	done
	cal_seq=(${cal_seq[*]} ${curr_cal[*]})
	if test $((${#cal_seq[*]} % 7)) -ne 0; then
		for i in `seq 6 $((${#cal_seq[*]} % 7))`; do
			cal_seq=(${cal_seq[*]} "__")
		done
	fi
	while test ${#week} -lt $((20 - ${EOM[0]})); do
		week="_"${week}"_"
	done
	if test ${#week} -gt $((20 - ${EOM[0]})); then
		week=${week:1:$((${#week} - 1))}
	fi
	week=${week}"__"
	for i in `seq 1 $((${#cal_seq[*]} / 7))`; do
		week[$i]=${cal_seq[@]:$((($i - 1) * 7)):7}"__"
	done
}
for k in `seq 1 $opt`; do
	stack=$diff_m
	declare -a week=()
	mkcal $opt
	for j in `seq 0 7`; do
		lines[$j]=${lines[$j]-''}${week[$j]-'______________________'}
	done
	diff_m=$(($stack + 1))
	if test $k -eq 2; then
		year=$curr_y
		while test ${#year} -lt 64; do
			year="_"${year}"_"
		done
		if test ${#year} -gt 64; then
			year=${year:1:$((${#year} - 1))}
		fi
		echo $year | sed -e 's/_/ /g' -e 's/ *$//'
	fi
done
for i in `seq 0 7`; do
	echo ${lines[$i]} | sed -e 's/_/ /g' -e 's/ *$//'
done
