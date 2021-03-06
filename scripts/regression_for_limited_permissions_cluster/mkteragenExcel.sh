#!/bin/sh

#Writen by: Idan Weinstein
#Date: 25-5-2011 

if [ -z "$MY_HADOOP_HOME" ]
then
        echo "please export MY_HADOOP_HOME"
        exit 1
fi

if [ -z "$HADOOP_CONF_DIR" ]
then
        HADOOP_CONF_DIR=$MY_HADOOP_HOME/conf
fi

cd $MY_HADOOP_HOME

if [ -z "$DATA_SET" ]
then
	DATA_SET="1 5 10 20 40 80"
fi

if [ -z "$DATA_SET_TYPE" ]
then
        DATA_SET_TYPE=node
fi


nodes=`cat "$HADOOP_CONF_DIR/slaves" | grep ^[[:alnum:]] -c`

for i in $DATA_SET; do 
	if [ "$DATA_SET_TYPE" = "node" ]
	then
		DATA_SET_TOTAL=$DATA_SET_TOTAL" "$(($i*nodes)); 
	else
		DATA_SET_TOTAL=$DATA_SET_TOTAL" "$i
	fi
done


if (($nodes == 0)); then
        echo "Failed to calculate the number of slaves (using \'$MY_HADOOP_HOME\slaves\' file)"
fi

disks=$((`cat $HADOOP_CONF_DIR/hdfs-site.xml | grep -A 1 ">dfs.data.dir<" | grep -o "," | wc -l | sed s/\ //g` + 1))

if (($disks == 0)); then
        echo "Failed to calculate the number of disks (using \'$MY_HADOOP_HOME\hdfs-site.xml\' file , value of \'dfs.data.dir'\)"
fi

nmaps=$((nodes))

echo "$0: TeraGen - Dynamic Parameters (user can export)"
echo "$0: TeraGen ---------------------------------------"
echo "$0: TeraGen - DATA_SET_TYPE=$DATA_SET_TYPE (node=size per node , cluster=size for whole cluster)"
echo "$0: TeraGen - DATA_SET=$DATA_SET"
echo ""
echo "$0: TeraGen - Static Parameters (user can not export)"
echo "$0: TeraGen ---------------------------------------"
echo "$0: TeraGen - DATA_SET_TOTAL=$DATA_SET_TOTAL (data set size for whole cluster)"
echo "$0: TeraGen - Number of saves = $nodes slaves"
echo "$0: TeraGen - Number of local disks per node = $disks (counts seperated commas on hdfs-site.xml)"
echo "$0: TeraGen - -Dmapred.map.tasks=${nmaps}"

if [ "$1" == "-show" ]
then
        exit 0;
fi


if [[ $@ == "*-rmr*" ]]
then
	echo hadoop fs -rmr /terasort/input
	hadoop fs -rmr /terasort/input
fi


n=0
# for shorter execution:
#if (($SLAVES_COUNT == 1))
#then
# DATA_SET_TOTAL="2"
#else
# DATA_SET_TOTAL="4"
#fi
#echo "$0: NEW DATA_SET_TOTAL=$DATA_SET_TOTAL"

for i in ${DATA_SET_TOTAL}; do
	n=$((n+1))
	size=$((i * 10000000))
	echo hadoop jar hadoop*examples*.jar teragen -Dmapred.map.tasks=${nmaps} ${size} $CURRENT_TERAGEN/teradata${i}G.${n}
	hadoop jar hadoop*examples*.jar teragen -Dmapred.map.tasks=${nmaps} ${size} $CURRENT_TERAGEN/teradata${i}G.${n}
	if (($TEST_RUN_FLAG == 1));then
		break
	fi
done



