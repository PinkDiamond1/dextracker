#!/bin/bash

make install GAIA_BUILD_OPTIONS="cleveldb"

dexd init "t6" --home ./t6 --chain-id t6

dexd unsafe-reset-all --home ./t6

mkdir -p ./t6/data/snapshots/metadata.db

dexd keys add validator --keyring-backend test --home ./t6

dexd add-genesis-account $(dexd keys show validator -a --keyring-backend test --home ./t6) 100000000stake --keyring-backend test --home ./t6

dexd gentx validator 100000000stake --keyring-backend test --home ./t6 --chain-id t6

dexd collect-gentxs --home ./t6

dexd start --db_backend cleveldb --home ./t6
