#!/usr/bin/env bash

#this is a bench marking script that runs performance tests and collects the logs then outputs it

set -e 

if ! command -v stress-ng >/dev/null 2>&1; then
    sudo dnf install -y stress-ng
fi

sudo stress-ng --cpu 0 --cpu-method matrixprod --timeout 60s > /var/log/stress-ngBENCH.log 2>&1

sudo stress-ng --HDD 2 
