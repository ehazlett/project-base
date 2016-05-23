package version

var (
	name        = "project-base"
	version     = "0.1.0"
	description = "sample app"
	GitCommit   = "HEAD"
)

func Name() string {
	return name
}

func Version() string {
	return version + " (" + GitCommit + ")"
}

func Description() string {
	return description
}

func FullVersion() string {
	return Name() + " " + Version()
}
