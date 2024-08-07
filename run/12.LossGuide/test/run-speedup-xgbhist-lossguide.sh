#!/bin/bash

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgb-latest
fi

tagname=`basename $bin`

echo "run speedup test with tagname=$tagname"

if [ ! -f $bin ]; then
	echo "Usage: run-speedup.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

export RUNID=`date +%m%d%H%M%S`
#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
../bin/xgb-speedup.sh ${bin} higgs 10 8 hist 32 500000 1 0 8 lossguide
../bin/xgb-speedup.sh ${bin} higgs 10 12 hist 32 500000 1 0 64 lossguide
../bin/xgb-speedup.sh ${bin} higgs 10 16 hist 32 500000 1 0 64 lossguide

echo "================================"
echo " Speedup Test Results:"
echo "================================"
# binname, runid, trainingtime
echo -e "binname\trunid\ttrainingtime"
echo "ls -tr */SpeedUp*${tagname}*${RUNID}.csv | xargs cat | gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' "
ls -tr */SpeedUp*${tagname}*${RUNID}*.csv | xargs cat | gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' 
