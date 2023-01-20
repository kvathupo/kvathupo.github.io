#!/bin/bash
for i in {1..10}
do
    if MAX_JOBS=16 DEBUG=1 USE_KINETO=0 USE_ITT=0 USE_DISTRIBUTED=0 USE_MKLDNN=0 USE_CUDA=0 python3 setup.py develop
    then
        break
    fi
    sleep 2
done
