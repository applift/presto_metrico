.PHONY: clean

REPO	= github.com/applift/presto_metrico
BIN		= presto_metrico

BENCH	= .
TESTS	= .

CWD 		= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VENDOR 		= $(CWD)/vendor
SRC 		= $(shell find . -type f \( -iname '*.go' ! -iname "*_test.go" \) -not -path "./vendor/*")
SRC_TEST 	= $(shell find . -type f -name '*_test.go' -not -path "./vendor/*")
SRC_VENDOR 	= $(shell find ./vendor -type f \( -iname '*.go' ! -iname "*_test.go" \))
PKGS 		= $(shell cd $(GOPATH)/src/$(REPO) && go list ./... | grep -v /vendor/)

V=$(shell git describe --always --tags --dirty)
GOOPTS=-installsuffix cgo -ldflags '-s -w'

###
### dist
###

dist: \
	dist/$(BIN)-$(V)-darwin-amd64.tar.gz \
	dist/$(BIN)-$(V)-linux-amd64.tar.gz

dist/$(BIN)-$(V)-%-amd64.tar.gz: dist/%/$(BIN)
	tar -czf $@ -C ${<D} $(notdir $^)

dist/%/$(BIN): $(SRC) $(SRC_VENDOR)
	@mkdir -p $(@D)
	GOPATH=$(GOPATH) CGO_ENABLED=0 GOOS=$* go build $(GOOPTS) -o $@ $(REPO)

clean-dist:
	rm -rf dist


###
### clean
###

clean: clean-dist

