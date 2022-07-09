ifeq ($(OS),Windows_NT)
 PLATFORM="win"
else
 ifeq ($(shell uname),Darwin)
  PLATFORM="mac"
 else
  PLATFORM="linux"
 endif
endif

ifeq ($(PREFIX),)
    PREFIX := /usr/local/bin
endif

BINARY="go-socks5-server"
B_MAC=${BINARY}-darwin
B_LINUX=${BINARY}-linux
B_WIN=${BINARY}-windows.exe

DOCKER_VER=1
DOCKER_NAME="ichenhe/go-socks5-server"

default:
	# outs dir should be synced with gh-actions:release
	GOARCH=amd64 GOOS=darwin go build -o "bin/${B_MAC}"
	GOARCH=amd64 GOOS=linux go build -o "bin/${B_LINUX}"
	GOARCH=amd64 GOOS=windows go build -o "bin/${B_WIN}"

test:
	@go test ./...

docker:
	@echo "Build docker image: ${DOCKER_NAME}:${DOCKER_VER} and tag it with ${DOCKER_NAME}:latest ..."
	docker build -t ${DOCKER_NAME}:${DOCKER_VER} .
	docker tag ${DOCKER_NAME}:${DOCKER_VER} ${DOCKER_NAME}:latest

clean:
	@rm -rf bin
	@go clean

install:
	@if [ ${PLATFORM} == "mac" ]; then \
	    cp "bin/${B_MAC}" "${PREFIX}/${BINARY}"; \
	elif [ ${PLATFORM} == "linux" ]; then \
	    cp "bin/${B_LINUX}" "${PREFIX}/${BINARY}"; \
	else \
	  	echo "Only support mac/unix-like system!"; \
	fi

uninstall:
	@if [ ${PLATFORM} == "win" ]; then \
	    echo "Only support mac/unix-like system!"; \
	else \
	  	rm "${PREFIX}/${BINARY}"; \
	fi

.PHONY: list fmt test docker clean doc
