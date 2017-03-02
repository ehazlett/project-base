CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=project-base
REPO?=ehazlett/$(APP)
TAG?=latest
MEDIA_SRCS=$(shell find ui/ -type f \
	-not -path "ui/dist/*" \
	-not -path "ui/node_modules/*")

all: media build

build:
	@cd cmd/$(APP) && go build -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" .

build-static:
	@cd cmd/$(APP) && go build -a -tags "netgo static_build" -installsuffix netgo -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" .

dev-setup:
	@echo "This could take a while..."
	@glide install
	@npm install --loglevel verbose -g gulp browserify babelify
	@cd ui && npm install --loglevel verbose
	@cd ui/node_modules/semantic-ui && gulp install

media: media-semantic media-app

media-semantic: ui/dist/.bundle_timestamp
ui/dist/.bundle_timestamp: $(MEDIA_SRCS)
	@cp -f ui/semantic.theme.config ui/semantic/src/theme.config
	@cp -r ui/semantic.theme ui/semantic/src/themes/app
	@cd ui/semantic && gulp build
	@mkdir -p ui/dist
	@cd ui && rm -rf dist/semantic* dist/themes
	@cp -f ui/semantic/dist/semantic.min.css ui/dist/semantic.min.css
	@cp -f ui/semantic/dist/semantic.min.js ui/dist/semantic.min.js
	@mkdir -p ui/dist/themes/default && cp -r ui/semantic/dist/themes/default/assets ui/dist/themes/default/
	@touch ui/dist/.bundle_timestamp

media-app:
	@mkdir -p ui/dist
	@cd ui && rm -rf dist/bundle.js
	@# add frontend ui components here
	@cd ui/src && browserify app/* -t babelify --outfile ../dist/bundle.js

image: build-static
	@mkdir -p build
	@cp -r cmd/$(APP)/$(APP) build/
	@cp -r ui build/
	@rm -rf build/ui/node_modules build/ui/semantic/{gulpfile.js,src,tasks} build/ui/semantic.json
	@docker build -t $(REPO):$(TAG) .

release: image
	@docker push $(REPO):$(TAG)

test: build
	@go test -v ./...

clean:
	@rm -rf cmd/$(APP)/$(APP)
	@rm -rf build
	@rm -rf ui/dist

.PHONY: add-deps build build-static dev-setup media media-semantic media-app image release test clean
