package main

import (
	"net/http"

	"github.com/codegangsta/cli"
	"github.com/ehazlett/project-base/version"
	"github.com/sirupsen/logrus"
)

var RunCommand = cli.Command{
	Name:   "run",
	Usage:  "start server",
	Action: runAction,
	Flags: []cli.Flag{
		cli.StringFlag{
			Name:  "listen, l",
			Usage: "listen address",
			Value: ":8080",
		},
		cli.StringFlag{
			Name:  "ui-dir, s",
			Usage: "path to ui media directory",
			Value: "ui",
		},
	},
}

func runAction(c *cli.Context) {
	logrus.Info(version.FullVersion())

	listenAddr := c.String("listen")
	uiDir := c.String("ui-dir")

	globalMux := http.NewServeMux()
	// static handler
	globalMux.Handle("/", http.FileServer(http.Dir(uiDir)))

	s := &http.Server{
		Addr:    listenAddr,
		Handler: globalMux,
	}

	logrus.Infof("api started: addr=%s", listenAddr)
	if err := s.ListenAndServe(); err != nil {
		logrus.Fatal(err)
	}

}
