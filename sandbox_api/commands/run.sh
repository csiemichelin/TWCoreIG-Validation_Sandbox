#!/bin/bash

command1="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-01.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command2="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-02.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command3="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-03.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command4="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-04.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command5="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-05.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command6="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-06.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command7="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-07.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command8="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-08.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command9="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-09.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"
command10="java -jar ../validator_cli.jar /home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/input/bundle-10.json -version 4.0 -ig tw.gov.mohw.twcore -watch-mode all"

# Function to execute a command and write to a specified output file
run_command() {
    local command=$1
    local output_file=$2
    local previous_line=""

    $command | {
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

# Run three different commands in the background
run_command "$command1" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-01.txt" &
run_command "$command2" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-02.txt" &
run_command "$command3" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-03.txt" &
run_command "$command1" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-04.txt" &
run_command "$command2" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-05.txt" &
run_command "$command3" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-06.txt" &
run_command "$command1" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-07.txt" &
run_command "$command2" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-08.txt" &
run_command "$command3" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-09.txt" &
run_command "$command3" "/home/michelin/TWCoreIG-Validation_Sandbox/sandbox_api/output_cli/outputcli-10.txt" &

# Wait for all background jobs to finish
wait