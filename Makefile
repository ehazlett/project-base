CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=project-base
REPO?=ehazlett/$(APP)
TAG?=latest
export GO15VENDOREXPERIMENT=1
MEDIA_SRCS=$(shell find public/ -type f \
	-not -path "public/dist/*" \
	-not -path "public/node_modules/*")

all: media build

add-deps:
	@godep save -t ./...

build:
	@cd cmd/$(APP) && go build -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" .

build-static:
	@cd cmd/$(APP) && go build -a -tags "netgo static_build" -installsuffix netgo -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" .

dev-setup:
	@echo "This could take a while..."
	@npm install --loglevel verbose -g gulp browserify babelify
	@cd public && npm install --loglevel verbose
	@cd public/node_modules/semantic-ui && gulp install

media: media-semantic media-app

media-semantic: public/dist/.bundle_timestamp
public/dist/.bundle_timestamp: $(MEDIA_SRCS)
	@cp -f public/semantic.theme.config public/semantic/src/theme.config
	@cp -r public/semantic.theme public/semantic/src/themes/app
	@cd public/semantic && gulp build
	@mkdir -p public/dist
	@cd public && rm -rf dist/semantic* dist/themes
	@cp -f public/semantic/dist/semantic.min.css public/dist/semantic.min.css
	@cp -f public/semantic/dist/semantic.min.js public/dist/semantic.min.js
	@mkdir -p public/dist/themes/default && cp -r public/semantic/dist/themes/default/assets public/dist/themes/default/
	@touch public/dist/.bundle_timestamp

media-app:
	@mkdir -p public/dist
	@cd public && rm -rf dist/bundle.js
	@# add frontend ui components here
	@cd public/src && browserify app/* -t babelify --outfile ../dist/bundle.js

image: build-static
	@mkdir -p build
	@cp -r cmd/$(APP)/$(APP) build/
	@cp -r public build/
	@rm -rf build/public/node_modules build/public/semantic/{gulpfile.js,src,tasks} build/public/semantic.json
	@docker build -t $(REPO):$(TAG) .

release: image
	@docker push $(REPO):$(TAG)

test: build
	@go test -v ./...

clean:
	@rm -rf cmd/$(APP)/$(APP)
	@rm -rf build
	@rm -rf public/dist

.PHONY: add-deps build build-static dev-setup media media-semantic media-app image release test clean
