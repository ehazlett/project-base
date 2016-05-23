package main

import (
	"net/http"

	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/ehazlett/project-base/version"
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
			Name:  "public-dir, s",
			Usage: "path to public media directory",
			Value: "public",
		},
	},
}

func runAction(c *cli.Context) {
	log.Infof("project-base %s", version.FullVersion())

	listenAddr := c.String("listen")
	publicDir := c.String("public-dir")

	globalMux := http.NewServeMux()
	// static handler
	globalMux.Handle("/", http.FileServer(http.Dir(publicDir)))

	s := &http.Server{
		Addr:    listenAddr,
		Handler: globalMux,
	}

	log.Infof("api started: addr=%s", listenAddr)
	if err := s.ListenAndServe(); err != nil {
		log.Fatal(err)
	}

}
