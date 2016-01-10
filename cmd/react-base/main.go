package main

import (
	"os"

	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/ehazlett/react-base/cmd/react-base/serve"
	"github.com/ehazlett/react-base/version"
)

func main() {
	app := cli.NewApp()
	app.Name = version.FullName()
	app.Usage = "sample react app"
	app.Version = version.FullVersion()
	app.Author = "@ehazlett"
	app.Email = "github.com/ehazlett/react-base"
	app.Before = func(c *cli.Context) error {
		// enable debug
		if c.GlobalBool("debug") {
			log.SetLevel(log.DebugLevel)
			log.Debug("debug enabled")
		}

		return nil
	}
	app.Flags = []cli.Flag{
		cli.BoolFlag{
			Name:  "debug, D",
			Usage: "enable debug",
		},
	}
	app.Commands = []cli.Command{
		serve.Command,
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
