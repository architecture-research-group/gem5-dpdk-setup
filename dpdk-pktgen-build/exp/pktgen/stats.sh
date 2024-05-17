#!/bin/bash

# Function to calculate the average of an array of numbers
calculate_average() {
  local arr=("$@")
  local sum=0
  for num in "${arr[@]}"; do
    sum=$(bc -l <<< "$sum + $num")
  done
  local count=${#arr[@]}
  local average=$(bc -l <<< "$sum / $count")
  echo "$average"
}

# Function to calculate the standard deviation of an array of numbers
calculate_stdev() {
  local arr=("$@")
  local average=$(calculate_average "${arr[@]}")
  local sum_squares=0
  for num in "${arr[@]}"; do
    sum_squares=$(bc -l <<< "$sum_squares + ($num - $average)^2")
  done

	
  local variance=$(bc -l <<< "$sum_squares / (${#arr[@]}-1)")
  local stdev=$(bc -l <<< "sqrt($variance)")
  echo "$stdev"
}

margin_error() {
  local arr=("$@")
	local stdev=$(calculate_stdev "${arr[@]}")
	local z="1.96" # 95%CI
	local m=$(bc -l <<< "$stdev * $z / sqrt(${#arr[@]})")

	echo $m
}

readarray -t nums < <(cat $1)

# Calculate and display the standard deviation
if [[ "${#nums[@]}" -lt 5 ]]
then
	echo 100
else 
	echo $(margin_error ${nums[@]} )
fi

