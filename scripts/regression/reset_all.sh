#!/bin/bash
# Written by Idan Weinstein On 2011-7-19

if [ -z "$MY_HADOOP_HOME" ]
then
        echo $(basename $0): "please export MY_HADOOP_HOME"
        exit 1
fi

if [ -z "$HADOOP_CONFIGURATION_DIR" ]
then 
	HADOOP_CONFIGURATION_DIR=$MY_HADOOP_HOME/conf
fi

cd $MY_HADOOP_HOME



echo "$(basename $0): Stoping Hadoop"
eval $DFS_STOP
eval $MAPRED_STOP
sleep 2 


echo "$(basename $0): kill java/python/c++ process"
sudo pkill -9 '(java|python|NetMerger|MOFSupplier)'
sudo eval $EXEC_SLAVES pkill -9 \'\(java\|python\|NetMerger\|MOFSupplier\)\'
sleep 2

# check for processes that did not respond to termination signals
live_processes=$(( `eval $EXEC_SLAVES ps -e | egrep -c '(MOFSupplier|NetMerger|java)'` + `ps -e | egrep -c '(MOFSupplier|NetMerger|java)'`  )) 

if [ $live_processes != 0 ]
then
	echo LIVE PROCESSES ARE: $live_processes
	echo "$(basename $0): process are still alive after kill --> using kill -9"
	sudo pkill -9 '(java|python|NetMerger|MOFSupplier)'
	sudo eval $EXEC_SLAVES pkill -9 \'\(java\|python\|NetMerger\|MOFSupplier\)\'
fi

sleep 2
# check if after kill -9 there are live processes
live_processes=$(( `eval $EXEC_SLAVES ps -e | egrep -c '(MOFSupplier|NetMerger|java)'` + `ps -e | egrep -c '(MOFSupplier|NetMerger|java)'`  ))  

if [ $live_processes != 0 ]
then
	echo "LIVE PROCESSES ARE (SECOND TIME):" $live_processes
	#echo "LIVA PROCESSES ARE: " `eval $EXEC_SLAVES ps -e | egrep '(MOFSupplier|NetMerger|java)'`
	#echo `ps -e | egrep '(MOFSupplier|NetMerger|java)'`  
	defunct_processes=$((`ps -e | egrep '(MOFSupplier|NetMerger|java)' | egrep -c '\<defunct\>'` + `eval $EXEC_SLAVES ps -e | egrep '(MOFSupplier|NetMerger|java)'| egrep -c '\<defunct\>' `))
	#echo defunct_processes: $defunct_processes
	if (($live_processes > $defunct_processes))
	then
		echo DEFUNCT PROCESSES ARE: `ps -e | egrep '(MOFSupplier|NetMerger|java)' | egrep '\<defunct\>'` + `eval $EXEC_SLAVES ps -e | egrep '(MOFSupplier|NetMerger|java)'| egrep '\<defunct\>' `
		#eval $EXEC_SLAVES ps -ef | grep -E '(MOFSupplier|NetMerger|java)'
		echo "$(basename $0): ERROR: failed to kill processes"
		exit 1;
	fi
fi

if [[ $@ = *-ignore_logs ]]
then
        echo "$(basename $0): Ignore logs (reset_all won't delete them)"
else
        echo "$(basename $0): Clear logs dir"
        rm -rf $MY_HADOOP_HOME/logs/*
        eval $EXEC_SLAVES rm -rf $MY_HADOOP_HOME/logs/\*
fi

if [[  $@ = *-format* ]]
then

	#echo "$(basename $0): removing /data2 - /data5 files"

	echo "$(basename $0) formating namenode"
	echo "going to fm_part"
	$(dirname $0)/fm_part.sh 
	format_ans=$?
	if (( $format_ans==5 ));
	then
		echo "format failed!!"
		exit $SEC
	fi
	sleep 6

fi


exit 0;





