#!/bin/bash

# Function to check if a command is valid
check_valid_cmd() {
    cmd_to_check="$@"
    if ! eval "$cmd_to_check" &> /dev/null; then
        echo "The command '"$cmd_to_check"' is not valid" >&2
        return 1
    fi
}

# Function to time a command a specified number of times
time_x_times_cmd() {
    # Parse the arguments : format timeXtimesCmdCmd <number_of_tests> <cmd> 
    number_of_tests=$1
    cmd="${@:2}"

    # Validate the number of tests parameter
    if ! [[ $number_of_tests =~ ^[0-9]+$ ]] || [ "$number_of_tests" -lt 1 ] 2>/dev/null; then
        echo "The number of time repetition parameter is invalid" >&2
        return 1
    fi

    # Validate the command
    if ! check_valid_cmd "$cmd"; then
        return 1
    fi

    # Perform the timing
    echo "About to time the command '"$cmd"' $number_of_tests times."  
    time (
        for ((i = 1; i <= number_of_tests; i++)); do
            $cmd
        done > /dev/null
    )
    return 0
}

alias timex=time_x_times_cmd