package version

var (
	name        = "project-base"
	version     = "0.1.0"
	description = "sample app"
	// GitCommit is used in the build version
	GitCommit = "HEAD"
)

// Name is the name of the application
func Name() string {
	return name
}

// Version is the version of the application
func Version() string {
	return version + " (" + GitCommit + ")"
}

// Description is the description of the application
func Description() string {
	return description
}

// FullVersion is the application name and version info
func FullVersion() string {
	return Name() + " " + Version()
}
