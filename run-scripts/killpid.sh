#!/bin/bash

start=427485
stop=427596

for ((pid=start; pid <= stop; pid++)); do
    kill -9 $pid
done