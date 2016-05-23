package main

import (
	"os"

	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/ehazlett/project-base/version"
)

func main() {
	app := cli.NewApp()
	app.Name = version.Name()
	app.Usage = version.Description()
	app.Version = version.Version()
	app.Author = "@ehazlett"
	app.Email = ""
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
		RunCommand,
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
