#!/bin/bash
echo "Starting"
# Load Conda configuration
source $(conda info --base)/etc/profile.d/conda.sh

# Activate the Conda Environment
conda activate dplora

# Check if the environment was activated successfully
if [[ $? -ne 0 ]]; then
    echo "Failed to activate Conda environment 'dplora'"
    exit 1
fi

echo "Starting Server"
python server.py --num_clients 3 --rank 0 &
server_pid=$!
echo "Server PID: $server_pid"

sleep 10

echo "Starting Client 1"
python lora-client.py --num_clients 3 --rank 1 &
client1_pid=$!
echo "Client 1 PID: $client1_pid"

echo "Starting Client 2"
python lora-client.py --num_clients 3 --rank 2 &
client2_pid=$!
echo "Client 2 PID: $client2_pid"

echo "Starting Client 3"
python lora-client.py --num_clients 3 --rank 3 &
client3_pid=$!
echo "Client 3 PID: $client3_pid"

# Wait for all processes to complete
wait $server_pid $client1_pid $client2_pid $client3_pid
