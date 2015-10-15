# React Base
This is a base sample project for a minimal 
[React](https://facebook.github.io/react/) + [Go](http://golang.org) 
application.  It uses [Semantic UI](http://semantic-ui.com/) for the 
UI toolkit.

# Prerequisites
You must have the following:

- [npm](https://www.npmjs.com/) (tested on v0.12.3)
- [go](http://golang.org) (tested with 1.5)

# Setup
To get started, clone the repo and run:

`make dev-setup`

That will take a while as it has to get the npm dependencies and build the
native libs for media and JS compilation.

After that finishes, you should be able to run the following to build the
project:

`make`

That should compile the media, js and build the Go binary.  Once finished,
you can run the following to start the server:

`./cmd/react-base serve`

You should then be able to visit http://localhost:8080 to see the app.

![](/screenshot.png?raw=true)
