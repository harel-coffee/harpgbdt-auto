#!/bin/bash

bin=$1
if [ -z $bin  ] ; then
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-yfcc-release
    bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-slowdown-release
    bin2=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-unify-release
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
#../bin/xgb-speedup.sh ${bin} criteometa 10 8 lossguide 32 1562500 2 0 16 lossguide data_parallelism=1 group_parallel_cnt=32 topk=16 async_mixmode=2 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin} criteometa 10 8 lossguide 32 1562500 33 0 16 lossguide data_parallelism=1 group_parallel_cnt=32 topk=16 async_mixmode=2 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin} criteometa 10 12 lossguide 32 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin} criteometa 10 16 lossguide 32 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa

../bin/xgb-speedup.sh ${bin} criteometa 300 16 lossguide 32 1562500 0 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin} criteometa 300 16 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin2} criteometa 300 16 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa
#../bin/xgb-speedup.sh ${bin} criteometa 300 16 lossguide 32 1562500 33 0 8 depth data_parallelism=1 group_parallel_cnt=32 topk=128 async_mixmode=0 loadmeta=criteometa

#../bin/xgb-convergence.sh ${bin} criteometa 300 6 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=criteometa
#../bin/xgb-convergence.sh ${bin} criteometa 300 8 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=2 loadmeta=criteometa
#../bin/xgb-convergence.sh ${bin} criteometa 300 10 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa


#../bin/xgb-strongscale.sh ${bin} criteometa 10 8 lossguide 1562500 33 0 16 lossguide data_parallelism=1 group_parallel_cnt=32 topk=16 async_mixmode=2 loadmeta=criteometa
#../bin/xgb-strongscale.sh ${bin} criteometa 10 12 lossguide 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa
#../bin/xgb-strongscale.sh ${bin} criteometa 10 16 lossguide 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa

echo "================================"
echo " Speedup Test Results:"
echo "================================"
# binname, runid, trainingtime
echo -e "binname\trunid\ttrainingtime"
#find . -name "SpeedUp*${tagname}*.csv" -exec cat {} \; |gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' |sort
echo "ls -tr */SpeedUp*${tagname}*${RUNID}.csv | xargs cat | gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' "
ls -tr */SpeedUp*${tagname}*${RUNID}*.csv | xargs cat | gawk -F, '{printf("%s\t%s\t%s\n",$1,$2,$5)}' 
