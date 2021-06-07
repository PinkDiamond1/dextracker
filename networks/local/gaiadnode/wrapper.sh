#!/usr/bin/env sh

##
## Input parameters
##
BINARY=/dexd/${BINARY:-dexd}
ID=${ID:-0}
LOG=${LOG:-dexd.log}

##
## Assert linux binary
##
if ! [ -f "${BINARY}" ]; then
	echo "The binary $(basename "${BINARY}") cannot be found. Please add the binary to the shared folder. Please use the BINARY environment variable if the name of the binary is not 'dexd' E.g.: -e BINARY=dexd_my_test_version"
	exit 1
fi
BINARY_CHECK="$(file "$BINARY" | grep 'ELF 64-bit LSB executable, x86-64')"
if [ -z "${BINARY_CHECK}" ]; then
	echo "Binary needs to be OS linux, ARCH amd64"
	exit 1
fi

##
## Run binary with all parameters
##
export dexdHOME="/dexd/node${ID}/dexd"

if [ -d "$(dirname "${dexdHOME}"/"${LOG}")" ]; then
  "${BINARY}" --home "${dexdHOME}" "$@" | tee "${dexdHOME}/${LOG}"
else
  "${BINARY}" --home "${dexdHOME}" "$@"
fi

