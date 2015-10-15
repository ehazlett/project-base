CGO_ENABLED=0
GOOS=linux
GOARCH=amd64
COMMIT=`git rev-parse --short HEAD`
APP=react-base
REPO?=ehazlett/$(APP)
TAG?=latest
export GO15VENDOREXPERIMENT=1

all: media build

add-deps:
	@godep save
	@rm -rf Godeps

build:
	@cd cmd && go build -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" -o $(APP) .

build-static:
	@cd cmd && go build -a -tags "netgo static_build" -installsuffix netgo -ldflags "-w -X github.com/ehazlett/$(APP)/version.GitCommit=$(COMMIT)" -o $(APP) .

dev-setup:
	@echo "This could take a while..."
	@npm install --loglevel verbose -g gulp browserify babelify
	@cd public && npm install --loglevel verbose
	@cd public/node_modules/semantic-ui && gulp install

media: media-semantic media-app

media-semantic:
	@cp -f public/semantic.theme.config public/semantic/src/theme.config
	@cd public/semantic && gulp build
	@mkdir -p public/dist
	@cd public && rm -rf dist/semantic* dist/themes
	@cp -f public/semantic/dist/semantic.min.css public/dist/semantic.min.css
	@cp -f public/semantic/dist/semantic.min.js public/dist/semantic.min.js
	@mkdir -p public/dist/themes/default && cp -r public/semantic/dist/themes/default/assets public/dist/themes/default/

media-app:
	@mkdir -p public/dist
	@cd public && rm -rf dist/bundle.js
	@# add frontend ui components here
	@cd public/src && browserify app/* -t babelify --outfile ../dist/bundle.js

image: build-static
	@mkdir -p build
	@cp -r cmd/$(APP) build/
	@cp -r public build/
	@rm -rf build/public/node_modules build/public/semantic/{gulpfile.js,src,tasks} build/public/semantic.json
	@docker build -t $(REPO):$(TAG) .

release: image
	@docker push $(REPO):$(TAG)

test: build
	@go test -v ./...

clean:
	@rm cmd/$(APP)
	@rm -rf build
	@rm -rf public/dist/*

.PHONY: add-deps build build-static dev-setup media media-semantic media-app image release test clean
