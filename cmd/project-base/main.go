package main

import (
	"os"

	"github.com/codegangsta/cli"
	"github.com/ehazlett/project-base/version"
	"github.com/sirupsen/logrus"
)

func main() {
	app := cli.NewApp()
	app.Name = version.Name
	app.Usage = "project template"
	app.Version = version.BuildVersion()
	app.Author = "@ehazlett"
	app.Email = ""
	app.Before = func(c *cli.Context) error {
		// enable debug
		if c.GlobalBool("debug") {
			logrus.SetLevel(logrus.DebugLevel)
			logrus.Debug("debug enabled")
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
		runCommand,
	}

	if err := app.Run(os.Args); err != nil {
		logrus.Fatal(err)
	}
}
