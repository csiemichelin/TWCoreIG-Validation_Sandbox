#!/bin/bash

base_dir="/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api"
input_dir="$base_dir/input"
output_dir="$base_dir/output_cli"
cache_base_dir="/tmp"

# Function to execute a command with a specified cache directory and write to a specified output file
run_command() {
    local command=$1
    local output_file=$2
    local cache_dir=$3
    local previous_line=""

    FHIR_TX_CACHE=$cache_dir $command | {
        while IFS= read -r line
        do
            if [[ "$previous_line" == *"Watching for changes (1000ms cycle)"* ]]; then
                echo "$line" > "$output_file"
            else
                echo "$line" >> "$output_file"
            fi
            previous_line="$line"
        done
    }
}

# Array of commands and their corresponding output files
commands=(
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
    "$base_dir/validator_cli.jar $input_dir/initial.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
)

# Array of corresponding output files
output_files=(
    "$output_dir/outputcli-01.txt"
    "$output_dir/outputcli-02.txt"
    "$output_dir/outputcli-03.txt"
    "$output_dir/outputcli-04.txt"
    "$output_dir/outputcli-05.txt"
    "$output_dir/outputcli-06.txt"
    "$output_dir/outputcli-07.txt"
    "$output_dir/outputcli-08.txt"
    "$output_dir/outputcli-09.txt"
    "$output_dir/outputcli-10.txt"
)

# Run commands in the background
for i in "${!commands[@]}"; do
    run_command "java -jar ${commands[$i]}" "${output_files[$i]}" "$cache_base_dir/cache-$i" &
    sleep 10    
done

# Wait for all background jobs to finish
wait
