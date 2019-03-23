#!/bin/bash

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release
fi

tagname=`basename $bin`

if [ ! -f $bin ]; then
	echo "Usage: run-scaling.sh <bin>"
	echo "$bin not exist, quit"
	exit -1
fi

echo "run scaling test with tagname=$tagname"

export RUNID=`date +%m%d%H%M%S`

#"Usage: xgb-strongscale.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runid>"
#../bin/xgb-strongscale.sh ${bin} synsetmeta 10 8 lossguide 100000 28 0 8 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=synsetmeta
#../bin/xgb-strongscale.sh ${bin} synsetmeta 10 12 lossguide 100000 28 0 8 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=synsetmeta
#../bin/xgb-strongscale.sh ${bin} synsetmeta 10 16 lossguide 100000 28 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=synsetmeta
../bin/xgb-strongscale.sh ${bin} synsetmeta 300 8 lossguide 100000 1 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=0 loadmeta=synsetmeta
../bin/xgb-strongscale.sh ${bin} synsetmeta 300 12 lossguide 100000 28 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=synsetmeta
../bin/xgb-strongscale.sh ${bin} synsetmeta 300 16 lossguide 100000 28 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=synsetmeta



echo "================================"
echo " StrongScaling Test Results:"
echo "================================"
echo -e "binname\trunid\ttrainingtime"
#find . -name "StrongScale*${tagname}*.csv" -exec cat {} \; |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' |sort
echo "ls -tr */StrongScale*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}'"
ls -tr */StrongScale*${tagname}*${RUNID}.csv | xargs cat |gawk -F, '{printf("%s\t%s\t%s\t%s\n",$1,$2,$3,$6)}' 

