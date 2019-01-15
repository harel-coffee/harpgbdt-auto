#!/bin/bash

if [ $# -eq "0"  ] ; then
	echo "Usage: run-speedup.sh <bin>"
	exit -1
fi

tagname=$1
if [ -z $tagname  ] ; then
	tagname=byte-blockdense-longcube-threadinit
fi

echo "run speedup test with tagname=$tagname"

bin=../bin/xgboost-g++-omp-halftrick-noprefetch-${tagname}-release
if [ ! -f $bin ]; then
	echo "$bin not exist, quit"
	exit -1
fi
bin=../bin/xgboost-g++-omp-nohalftrick-noprefetch-${tagname}-release
if [ ! -f $bin ]; then
	echo "$bin not exist, quit"
	exit -1
fi

bin=../bin/xgboost-g++-omp-halftrick-noprefetch-${tagname}-release
../bin/xgb-speedup.sh ${bin} higgs 10 8 blockdense 32
../bin/xgb-speedup.sh ${bin} higgs 10 12 blockdense 32
../bin/xgb-speedup.sh ${bin} higgs 10 16 blockdense 32


bin=../bin/xgboost-g++-omp-nohalftrick-noprefetch-${tagname}-release
../bin/xgb-speedup.sh ${bin} higgs 10 8 blockdense 32
../bin/xgb-speedup.sh ${bin} higgs 10 12 blockdense 32
../bin/xgb-speedup.sh ${bin} higgs 10 16 blockdense 32


bin=../bin/xgboost-g++-omp-halftrick-noprefetch-${tagname}-release
../bin/xgb-speedup.sh ${bin} synset 10 8 blockdense 32 
../bin/xgb-speedup.sh ${bin} synset 10 12 blockdense 32 
../bin/xgb-speedup.sh ${bin} synset 10 13 blockdense 32 

bin=../bin/xgboost-g++-omp-nohalftrick-noprefetch-${tagname}-release
../bin/xgb-speedup.sh ${bin} synset 10 8 blockdense 32 
../bin/xgb-speedup.sh ${bin} synset 10 12 blockdense 32 
../bin/xgb-speedup.sh ${bin} synset 10 13 blockdense 32 

echo "================================"
echo " Speedup Test Results:"
echo "================================"
# binname, runid, trainingtime
echo -e "binname\trunid\ttrainingtime"
find . -name "SpeedUp*${tagname}*.csv" -exec cat {} \; |gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' |sort
