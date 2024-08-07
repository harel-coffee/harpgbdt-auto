#!/bin/bash

export _gbtproject_=`pwd`

export LD_LIBRARY_PATH=/opt/Anaconda3-5.0.1/lib

bin=../bin/xgboost-g++-omp-dense-halftrick-byte-splitonnode-sync-release
hist=../bin/xgb-latest


tagname=`basename $bin`

echo "run speedup test with tagname=$tagname"

if [ ! -f $bin ]; then
        echo "Usage: run-speedup.sh <bin>"
        echo "$bin not exist, quit"
        exit -1
fi

export RUNID=`date +%m%d%H%M%S`
#Usage: xgb-speedup.sh <bin> <dataset> <iter> <maxdepth> <tree_method> <thread> <row_blksize> <ft_blksize> <bin_blksize> <node_block_size> <growth_policy> <runids>"
../bin/xgb-convergence.sh ${bin} criteometa 300 8 lossguide 32 1562500 33 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=8 async_mixmode=2 loadmeta=criteometa missing_value=1

../bin/xgb-convergence.sh ${bin} criteometa 300 12 lossguide 32 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa missing_value=1

../bin/xgb-convergence.sh ${bin} criteometa 300 16 lossguide 32 1562500 33 0 32 lossguide data_parallelism=1 group_parallel_cnt=32 topk=32 async_mixmode=1 loadmeta=criteometa missing_value=1

../bin/xgb-convergence.sh ${bin} criteometa 300 12 lossguide 32 1562500 33 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=16 async_mixmode=0 loadmeta=criteometa missing_value=1
../bin/xgb-convergence.sh ${bin} criteometa 300 16 lossguide 32 1562500 33 0 8 lossguide data_parallelism=1 group_parallel_cnt=32 topk=16 async_mixmode=0 loadmeta=criteometa missing_value=1

../bin/xgb-convergence.sh ${bin} criteometa 300 8 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=2 loadmeta=criteometa missing_value=1
../bin/xgb-convergence.sh ${bin} criteometa 300 12 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=criteometa missing_value=1
../bin/xgb-convergence.sh ${bin} criteometa 300 16 lossguide 32 1562500 33 0 32 depth data_parallelism=1 group_parallel_cnt=32 topk=0 async_mixmode=1 loadmeta=criteometa missing_value=1


../bin/xgb-convergence.sh ${hist} criteo 300 8 hist 32 1582500 33 0 8 lossguide 
../bin/xgb-convergence.sh ${hist} criteo 300 8 hist 32 1582500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 8 feature 32


../bin/xgb-convergence.sh ${hist} criteo 300 12 hist 32 15122500 33 0 8 lossguide 
../bin/xgb-convergence.sh ${hist} criteo 300 12 hist 32 15122500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 12 feature 32

../bin/xgb-convergence.sh ${hist} criteo 300 16 hist 32 15162500 33 0 8 lossguide 
../bin/xgb-convergence.sh ${hist} criteo 300 16 hist 32 15162500 33 0 32 depth 
../bin/lightgbm-convergence.sh ../bin/lightgbm criteo 300 16 feature 32

