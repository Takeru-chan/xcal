#! /bin/sh
# @(#) xcal.sh ver.1.2  2014.12.27  (c)Takeru.
#
# Usage:
#      xcal.sh [-m month [year]]
#      xcal.sh [-y [year]]
#      xcal.sh [-3|+3]
#
# Description:
#      The xcal utility displays a simple calendar.
#      If auguments are not specified, the current month is displayed.
#
#      -m      Display the specified month.
#      -y      Display a calendar for the specified year.
#      -3      Display prev/current/next month output.
#      +3      Display current/next/after next month output.
#
#      Copyright (c) 2014 Takeru.
#      Released under the MIT license
#      http://opensource.org/licenses/MIT
#
#######################################################################
set -o nounset                              # Treat unset variables as an error
declare -a get_date=(`date '+%Y %m'`)
curr_y=${get_date[0]}
curr_m=${get_date[1]}; if test "${curr_m:0:1}" == "0"; then curr_m=${curr_m:1:1}; fi
						# ８進数扱いにならないようにvalue too great for baseエラー対策。
diff_m=0				# 今月からのオフセット値。
diff_y=0				# 今年からのオフセット値。
case $# in
	0)	opt="-m";;
	1)	loops=31		# カレンダーの表示月数。十の位が列数。一の位が行数。
		opt=$1;;
	2|3)loops=11
		opt=$1
		diff_y=$((${3-${curr_y}} - ${curr_y}));;
						# -mオプション処理。$3にデフォルト値を設定して[yaer]処理を簡略化。
	*)	echo $0: illegal option; exit 1;;
esac
case $opt in
	-3)	diff_m=-1
		if test $# -ne 1; then
			echo $0: illegal option; exit 1
		fi;;
	+3)	if test $# -ne 1; then
			echo $0: illegal option; exit 1
		fi;;
	-y)	loops=34
		diff_m=$((1 - ${curr_m}))			# 年表示は必ず１月始まり。
		if test $# -gt 2; then
			echo $0: illegal option; exit 1
		elif test ${2-${curr_y}} -ge 1902; then
			diff_y=$((${2-${curr_y}} - ${curr_y}))
		fi;;
	-m)	loops=11
		if test ${2-${curr_m}} -ge 1 -a ${2-${curr_m}} -le 12; then
			diff_m=$((${2-${curr_m}} - ${curr_m}))
		else
			echo $0: illegal option; exit 1
		fi;;
	*)	if test $# -ne 1; then
			echo $0: illegal option; exit 1
		elif test $opt -ge 1902; then
			loops=34
			diff_m=$((1 - ${curr_m}))
			diff_y=$(($opt - ${curr_y}))
		elif test $opt -ge 1 -a $opt -le 12; then
			diff_m=$(($opt - ${curr_m}))
			loops=11
		else
			echo $0: illegal option; exit 1
		fi;;
esac
function mkcal() {
	if test $diff_y -lt -112; then			# dateコマンドの仕様で1902年までしか遡れません。
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
	curr_m=${get_date[1]}; if test "${curr_m:0:1}" == "0"; then curr_m=${curr_m:1:1}; fi
							# ８進数扱いにならないようにvalue too great for baseエラー対策。
	curr_B=${get_date[2]}
	curr_d=${get_date[3]}
	start_o=`date -v${diff_m}m -v${diff_y}y -v-$(($curr_d - 1))d '+%w'`
	declare -a EOM=(0 31 28 31 30 31 30 31 31 30 31 30 31)
							# 月末日数列の0月部分は日本語環境フラグに使用。
	if test $((curr_y % 4)) -eq 0 -a $((curr_y % 100)) -ne 0 -o $((curr_y % 400)) -eq 0; then
		EOM[2]=$((EOM[2]+1))
	fi						# 閏年判定をして月末数列を書き換え。
	week=$curr_B			# デフォルトは英語環境。
	declare -a cal_seq=(Su Mo Tu We Th Fr Sa)
	if test "$LANG" == "ja_JP.UTF-8"; then
		EOM[0]=1			# 日本語環境フラグをON。
		week=$curr_m"月"
		declare -a cal_seq=(日 月 火 水 木 金 土)
	fi
	if test ${loops:0:1} -eq 1; then
		week=${week}"_"$curr_y
	fi
	if test $start_o -ne 0; then
		for i in `seq 1 $start_o`; do
			cal_seq=(${cal_seq[*]} "__")
		done
	fi						# 前月分の日付をダミーデータで埋めて書式を整える。
	declare -a curr_cal=()
	for i in `seq 1 ${EOM[$curr_m]}`; do
		curr_cal[$i]=$i
		if test $i -lt 10; then
			curr_cal[$i]="_"${curr_cal[$i]}
		fi					# 1桁の日付を2桁化して書式を整える。
		if test $i -eq $curr_d -a "$diff_m" == "+0" -a "$diff_y" == "+0"; then
			curr_cal[$i]="\033[47m"${curr_cal[$i]}"\033[0m"
		fi					# 本スクリプトの心臓。本日日付をエスケープシーケンスでマーク。
	done					# 配列の添字と日付を揃えることで判定処理を簡略化。
	cal_seq=(${cal_seq[*]} ${curr_cal[*]})
	if test $((${#cal_seq[*]} % 7)) -ne 0; then
		for i in `seq 6 $((${#cal_seq[*]} % 7))`; do
			cal_seq=(${cal_seq[*]} "__")
		done
	fi						# 翌月分の日付をダミーデータで埋めて書式を整える。
	while test ${#week} -lt $((20 - ${EOM[0]})); do
		week="_"${week}"_"
	done					# 月名ヘッダをセンタリング。
	if test ${#week} -gt $((20 - ${EOM[0]})); then
		week=${week:1:$((${#week} - 1))}
	fi
	week=${week}"__"		# 複数月表示に備えて月名ヘッダにデータ追記。
	for i in `seq 1 $((${#cal_seq[*]} / 7))`; do
		week[$i]=${cal_seq[@]:$((($i - 1) * 7)):7}"__"
	done					# 日付シーケンスを週ごとに分割し、複数月表示に備えてデータ追記。
}
for l in `seq 1 ${loops:1:1}`; do		# 年表示用ループ。
	declare -a lines=()
	for k in `seq 1 ${loops:0:1}`; do	# ３ヶ月表示用ループ。
		stack=$diff_m
		declare -a week=()
		mkcal
		for j in `seq 0 7`; do			# 月表示用ループ。
			lines[$j]=${lines[$j]-''}${week[$j]-'______________________'}
		done
		diff_m=$(($stack + 1))
		if test $k -eq 2; then			# 複数月表示時の年表示ヘッダ設定。
			year=$curr_y
			while test ${#year} -lt 64; do
				year="_"${year}"_"
			done
			if test ${#year} -gt 64; then
				year=${year:1:$((${#year} - 1))}
			fi
			if test $l -eq 1; then
				echo $year | sed -e 's/_/ /g' -e 's/ *$//'
				echo					# 年表示ヘッダをフィルタリング後に表示。
			fi
		fi
	done
	for i in `seq 0 7`; do
		echo ${lines[$i]} | sed -e 's/_/ /g' -e 's/ *$//'
	done								# 月データをフィルタリング後に表示。
done
