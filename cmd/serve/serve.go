package serve

import (
	"net/http"

	log "github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/ehazlett/react-base/version"
)

var Command = cli.Command{
	Name:   "serve",
	Usage:  "start server",
	Action: serveAction,
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

func serveAction(c *cli.Context) {
	log.Infof("react-base %s", version.FullVersion())

	listenAddr := c.String("listen")
	publicDir := c.String("public-dir")

	globalMux := http.NewServeMux()
	// static handler
	globalMux.Handle("/", http.FileServer(http.Dir(publicDir)))

	s := &http.Server{
		Addr:    listenAddr,
		Handler: globalMux,
	}

	log.Infof("api serving: addr=%s", listenAddr)
	if err := s.ListenAndServe(); err != nil {
		log.Fatal(err)
	}

}
