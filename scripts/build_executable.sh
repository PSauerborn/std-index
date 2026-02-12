#!/bin/bash

set -e
# CPU architecture of the host system
cpu_arch=$1

filename="bin/stdidx_$cpu_arch"

GOOS=linux GOARCH=$cpu_arch go build -o $filename .
