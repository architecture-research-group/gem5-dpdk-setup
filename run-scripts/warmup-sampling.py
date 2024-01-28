import time
import os

# Initialize parameters to store earlier values
earlier_values = {
    "system.cpu0.l2cache.overallMissRate::total": 0.0,
    "system.cpu1.l2cache.overallMissRate::total": 0.0,
    "system.cpu2.l2cache.overallMissRate::total": 0.0,
    "system.cpu3.l2cache.overallMissRate::total": 0.0,
}

# Initialize variables to keep track of samples and changes
samples = 0
consistent_changes = 0

# Specify the interval between samples (in seconds)
sampling_interval = 0.1  # Adjust as needed

# Define the log file path
log_file = "selected_params_log.txt"

# Keep track of the last line that was read
last_line_index = 0

# Open the log file for writing
with open(log_file, "w") as log:
    log.write("Selected Parameters Log\n")

# Main loop for monitoring stats
while True:
    # Read the stats file
    stats_file = os.path.join(os.path.expanduser("/workspaces/CAL-DPDK-GEM5/rundir/dpdk-l2fwd-bw/1NIC-64SIZE-2150786RATE-1Gbps-ddio-enabled-dpdk-l2fwd.sh/"), "stats.txt")
    with open(stats_file, "r") as f:
        lines = f.readlines()

    # Only process lines that haven't been read in the previous iteration
    new_lines = lines[last_line_index:]
    last_line_index = len(lines)

    # Initialize variables to store selected parameters
    selected_params = {
        "system.switch_cpus0.instsIssued": 0,
        "system.switch_cpus0.committedInsts": 0,
        "system.switch_cpus0.totalIpc": 0,
        "system.switch_cpus1.instsIssued": 0,
        "system.switch_cpus1.committedInsts": 0,
        "system.switch_cpus1.totalIpc": 0,
        "system.switch_cpus2.instsIssued": 0,
        "system.switch_cpus2.committedInsts": 0,
        "system.switch_cpus2.totalIpc": 0,
        "system.switch_cpus3.instsIssued": 0,
        "system.switch_cpus3.committedInsts": 0,
        "system.switch_cpus3.totalIpc": 0,
    }

    # Parse and update the selected parameters from new lines
    for line in new_lines:
        parts = line.split()
        if len(parts) >= 2:
            param_name = parts[0]
            param_value = parts[1]
            if param_name in selected_params:
                selected_params[param_name] = float(param_value)

    # Check if the earlier values have been initialized
    if all(value != 0.0 for value in earlier_values.values()):
        # Calculate the differences and check consistency
        consistent = True
        for param_name in earlier_values:
            earlier_value = earlier_values[param_name]
            current_value = selected_params.get(param_name, 0.0)
            difference = abs(current_value - earlier_value)
            if difference > 0.05 * earlier_value:
                consistent = False
                break

        # If consistent, increment the count; otherwise, reset
        if consistent:
            consistent_changes += 1
        else:
            consistent_changes = 0

        # If consistent for three samples, print and log the selected parameters
        if consistent_changes == 3:
            log_message = "Selected Parameters:\n"
            with open(log_file, "a") as log:
                log.write(log_message)
            print(log_message)
            for param_name in selected_params:
                log_message = f"{param_name}: {selected_params[param_name]}\n"
                with open(log_file, "a") as log:
                    log.write(log_message)
                print(log_message)
            break

    # Update the earlier values
    earlier_values = {param_name: selected_params[param_name] for param_name in earlier_values}

    # Increment the sample count
    samples += 1

    # Wait for the next sampling interval
    time.sleep(sampling_interval)
