STEP_CODE="\033[0;33m"
CLEAN_CODE="\033[0m"

echo -e "\n${STEP_CODE} Starting trinci node..${CLEAN_CODE}\n"

cd $HOME/trinci

# Generate rando network name
NETWORK_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Start the binary
./trinci --validator --network $NETWORK_NAME --log-level debug
