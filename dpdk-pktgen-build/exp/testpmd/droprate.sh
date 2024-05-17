#!/bin/bash

# Remember to also change the stats file where data is read from
# Also change the t variable

input_file="configs-rxptx.txt"
output_file="testpmd_rxptx_output_droprate.csv"

rm -f $output_file
# Create or truncate the output CSV file
> "$output_file"

# Define the threshold value
threshold=0.80

# Process the input file
for t in 1 100; do
while read -u3 a b c ; do
	echo -n $a,$b,$c,$t, >> $output_file
# Initialize a counter
count=0
sum=0
sum_rx_value=0
sum_rx_dropped=0
sum_tx_value=0
sum_tx_dropped=0
rx_value=0
rx_dropped=0
tx_value=0
tx_dropped=0
number=0
flag=0
# Process the input file
while IFS= read -r line; do
  # Increment the counter
  ((count++))
  
  # Check if it's the 3rd line in every 4-line group
  if [[ $count -eq 3 ]]; then
    rx_line="$line"
    ((number++))
    ((flag++))
  elif [[ $count -eq 4 ]]; then
    tx_line="$line"
    # Reset the counter
    count=0

    # Extract values from the 3rd and 4th lines
    rx_value=$(grep -o "RX-total: [0-9]*" <<< "$rx_line" | awk '{print $2}')
    rx_dropped=$(grep -o "RX-dropped: [0-9]*" <<< "$rx_line" | awk '{print $2}')
    tx_value=$(grep -o "TX-total: [0-9]*" <<< "$tx_line" | awk '{print $2}')
    tx_dropped=$(grep -o "TX-dropped: [0-9]*" <<< "$tx_line" | awk '{print $2}')
    
    # Calculate the drop rate
    if [[ $rx_value -ne 0 ]]; then
      drop_rate=$(bc <<< "scale=6; ($rx_dropped + $tx_dropped) / $rx_value")
      
      # Check if the drop rate is greater than the threshold
      #if (( $(bc <<< "$drop_rate > $threshold") )); then
	#drop_rate=0
	#((flag--))
      #fi
    else
      drop_rate="0"
      ((flag--))
    fi
    # Append the drop rate to the CSV file
    sum=$(bc <<< "scale=6; $sum  + $drop_rate")
    sum_rx_value=$(bc <<< "scale=6; $sum_rx_value  + $rx_value")
    sum_rx_dropped=$(bc <<< "scale=6; $sum_rx_dropped  + $rx_dropped")
    sum_tx_value=$(bc <<< "scale=6; $sum_tx_value  + $tx_value")
    sum_tx_dropped=$(bc <<< "scale=6; $sum_tx_dropped  + $tx_dropped")
    #echo "$rx_value, $rx_dropped, $tx_value, $tx_dropped, $drop_rate" >> "$output_file"
 
    if [[ $number -eq 7 ]]; then
    	average_drop_rate=$(bc <<< "scale=6; $sum/$flag")
	average_rx_value=$(bc <<< "scale=6; $sum_rx_value/$flag")
	average_rx_dropped=$(bc <<< "scale=6; $sum_rx_dropped/$flag")
	average_tx_value=$(bc <<< "scale=6; $sum_tx_value/$flag")
	average_tx_dropped=$(bc <<< "scale=6; $sum_tx_dropped/$flag")
	echo "$average_rx_value, $average_rx_dropped, $average_tx_value, $average_tx_dropped, $average_drop_rate" >> "$output_file"
    fi
  fi
done < "stats-rxptx-sapphire/${a}_${b}_${c}_${t}.txt"
done 3< $input_file
done
