#!/bin/sh

set -o errexit -o nounset

CHAINID=$1
GENACCT=$2

if [ -z "$1" ]; then
  echo "Need to input chain id..."
  exit 1
fi

if [ -z "$2" ]; then
  echo "Need to input genesis account address..."
  exit 1
fi

# Build genesis file incl account for passed address
coins="10000000000stake,100000000000samoleans"
dexd init --chain-id $CHAINID $CHAINID
dexd keys add validator --keyring-backend="test"
dexd add-genesis-account $(dexd keys show validator -a --keyring-backend="test") $coins
dexd add-genesis-account $GENACCT $coins
dexd gentx validator 5000000000stake --keyring-backend="test" --chain-id $CHAINID
dexd collect-gentxs

# Set proper defaults and change ports
sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.dex/config/config.toml
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/g' ~/.dex/config/config.toml
sed -i 's/timeout_propose = "3s"/timeout_propose = "1s"/g' ~/.dex/config/config.toml
sed -i 's/index_all_keys = false/index_all_keys = true/g' ~/.dex/config/config.toml

# Start the dex
dexd start --pruning=nothing
