#!/bin/bash

trap "kill -- -$$" EXIT
trap terminate SIGINT
terminate(){
    echo "Terminating..."
    pkill -SIGINT -P $$
    exit
}

./scripts/startMongo.sh &
./scripts/startBackend.sh &
./scripts/startFrontend.sh &

wait
