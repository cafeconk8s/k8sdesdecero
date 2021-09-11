#!/bin/bash

NODE=$1

if [ $# -eq 0 ]; then
    echo "No arguments provided, need to specific the node name, use "kubectl get nodes""
    exit 1
fi

echo "INFO: DRAINING NODE"
kubectl drain $NODE --force --ignore-daemonsets
