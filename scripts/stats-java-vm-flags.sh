#!/bin/sh

#echo "plist($plist)"
#echo "slist($slist)"
function jvm_flags_stats {
	local output_dir=/local
	local log_file=$output_dir/${1-"jvm_flags.txt"}

	local plist=`ps -o pid,psr,comm -xH | grep java | awk '{++stats[$1]} END{for (i in stats) {print i}}'`
	local slist=`ps -o pid,psr,comm -xH | grep java | awk '{++stats[$1]} END{for (i in stats) {print stats[i]}}'`

	echo "stats jvm flags" > $log_file
	jps -m -l -v -V | sed 's/ /,/g' >> $log_file
}

function jvm_flags_stats_2 {
	local output_dir=/local
	local log_file=$output_dir/${1-"jvm_flags.txt"}

	local plist=`ps -o pid,psr,comm -xH | grep java | awk '{++stats[$1]} END{for (i in stats) {print i}}'`
	local slist=`ps -o pid,psr,comm -xH | grep java | awk '{++stats[$1]} END{for (i in stats) {print stats[i]}}'`

	echo "stats jvm flags" > $log_file
	echo "processes:" >> $log_file
	echo $plist >> $log_file
	echo "counts:" >> $log_file
	echo $slist >> $log_file

	for i in $plist; do
		echo "p($i)" >> $log_file
		jcmd $i VM.flags >> $log_file 
	done
}
