#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            CONFIRM=true
            ;;
        *)
            CONFIRM=false
            ;;
    esac
}

create_trinci_folder() {
    cd $HOME
    mkdir $HOME/trinci
    mkdir $HOME/trinci/data
}

echo -e "Trinci node installer - v0.0.1\n"

SUCCESS_CODE="\033[0;32m"
ERROR_CODE="\033[0;31m"
STEP_CODE="\033[0;33m"
CLEAN_CODE="\033[0m"
TRINCI_NODE_REPO="https://github.com/affidaty-blockchain/trinci-node.git"

echo -e "${STEP_CODE}Step 1. Download the source code. \n ${CLEAN_CODE}"
cd $HOME

if [ -d "trinci-node" ]; then
	echo -e "Source folder already exists. If you want a clean installation remove the trinci-node folder.."
	echo -e "\n    $ rm -rf /home/node/trinci-node"
	echo -e "\nExec again this script if you want a clean build.\n"
else
	#download node source code
	git clone $TRINCI_NODE_REPO
fi

echo -e "${STEP_CODE}Step 2. Compile the source code. \n"

cd $HOME/trinci-node
echo "1.56.1" > rust-toolchain
# Compile the source code
cargo build

if [ $? -eq 0 ]; then
	echo -e "\n${SUCCESS_CODE}Compilation ended successfully! \n ${CLEAN_CODE}"
else
	echo -e "\n${ERROR_CODE}Something went wrong compiling the source code. \n ${CLEAN_CODE}"
	exit 1
fi

echo -e "${STEP_CODE}Step 3. Copy the binary and the config files. \n"

if [ -d $HOME/trinci ]; then
	echo -e "Binary folder already exists, do you want to clean it? All data stored into the node will be deleted."
	confirm
	if [ $CONFIRM == true ]; then
		rm -rf $HOME/trinci
		create_trinci_folder
	fi
else
	# Create trinci folder
	create_trinci_folder
fi

cp $HOME/trinci-node/target/debug/trinci-node $HOME/trinci/trinci
cp $HOME/trinci-node/data/bootstrap.wasm $HOME/trinci/data/


echo -e "${SUCCESS_CODE}Copy completed!${CLEAN_CODE}\n"

echo -e "${STEP_CODE}Step 4. Starting node... \n"

cd $HOME/trinci

# Generate rando network name
NETWORK_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Start the binary
./trinci --validator --network $NETWORK_NAME --log-level debug
