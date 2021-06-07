package main

import (
	"os"

	"github.com/mydexchain/chain-sdk/server"
	svrcmd "github.com/mydexchain/chain-sdk/server/cmd"

	app "github.com/mydexchain/dextracker/v3/app"
	"github.com/mydexchain/dextracker/v3/cmd/dexd/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}
