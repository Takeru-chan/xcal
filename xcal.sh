#! /bin/sh
# @(#) xcal.sh ver.1.0  2014.12.24  (c)Takeru.
#
# Usage:
#      xcal.sh -m month [year]
#
# Description:
#      The xcal utility displays a simple calendar.
#      If auguments are not specified, the current month is displayed.
#
#      -m      Display the specified month.
#
#      Copyright (c) 2014 Takeru.
#      Released under the MIT license
#      http://opensource.org/licenses/MIT
#
#############################################################
set -o nounset                              # Treat unset variables as an error
curr_y=`date '+%Y'`
curr_m=`date '+%m'`
diff_m=0
diff_y=0
if test $# -ne 0; then
	if test "$1" == "-m"; then
		if test $2 -ge 1 -a $2 -le 12; then
			diff_m=$(($2 - $curr_m))
		else
			echo $0: illegal option $2
			exit 1
		fi
		if test $# -eq 3; then
			diff_y=$(($3 - $curr_y))
		fi
	else
		echo $0: illegal option $1
		exit 1
	fi
fi
if test $diff_y -lt -112; then
	echo $0: cannot calculate...
	exit 1
fi
if test "${diff_m:0:1}" != "-"; then
	diff_m=`echo "+"$diff_m`
fi
if test "${diff_y:0:1}" != "-"; then
	diff_y=`echo "+"$diff_y`
fi
curr_y=`date -v${diff_m}m -v${diff_y}y '+%Y'`
curr_m=`date -v${diff_m}m -v${diff_y}y '+%m'`
curr_b=`date -v${diff_m}m -v${diff_y}y '+%b'`
curr_d=`date -v${diff_m}m -v${diff_y}y '+%e'`
start_o=`date -v${diff_m}m -v${diff_y}y -v-$(($curr_d - 1))d '+%w'`
declare -a EOM=(0 31 28 31 30 31 30 31 31 30 31 30 31)
if test $((curr_y % 4)) -eq 0 -a $((curr_y % 100)) -ne 0 -o $((curr_y % 400)) -eq 0; then
	EOM[2]=$((EOM[2]+1))
fi
if test "${curr_m:0:1}" == "0"; then
	curr_m=`echo " "${curr_m:1:1}`
fi
if test "$LANG" == "ja_JP.UTF-8"; then
	echo "     "$curr_m"月 "$curr_y
	declare -a prev_cal=(日 月 火 水 木 金 土)
else
	echo "      "$curr_b" "$curr_y
	declare -a prev_cal=(Su Mo Tu We Th Fr Sa)
fi
if test $start_o -ne 0; then
	for i in `seq 1 $start_o`; do
		prev_cal[$(($i + 7))]=`echo "__"`
	done
fi
for i in `seq 1 ${EOM[$curr_m]}`; do
	curr_cal[$i]=$i
	if test $i -lt 10; then
		curr_cal[$i]=`echo "_"${curr_cal[$i]}`
	fi
	if test $i -eq $curr_d -a "$diff_m" == "+0" -a "$diff_y" == "+0"; then
		curr_cal[$i]=`echo -e "\033[47m"${curr_cal[$i]}"\033[0m"`
	fi
done
cal_seq=(${prev_cal[*]} ${curr_cal[*]})
echo ${cal_seq[*]} | xargs -n 7 | sed 's/_/ /g'
echo
