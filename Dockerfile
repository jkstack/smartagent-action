FROM debian:stable-slim

ARG GO_VERSION=1.20

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl git make fakeroot wixl nsis dos2unix && \
    apt-get install -y busybox unzip && \
    curl -L https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz|tar -xz -C /usr/local && \
    mkdir -p /usr/local/go10 && \
    curl -L https://dl.google.com/go/go1.10.8.linux-amd64.tar.gz|tar -xz -C /usr/local/go10 --strip-components=1 --exclude=gocache && \
    mv /usr/local/go10/bin/go /usr/local/go10/bin/go10 && \
    mv /usr/local/go10/bin/godoc /usr/local/go10/bin/godoc10 && \
    mv /usr/local/go10/bin/gofmt /usr/local/go10/bin/gofmt10 && \
    curl -L https://nsis.sourceforge.io/mediawiki/images/e/ef/NSIS_Simple_Service_Plugin_Unicode_1.30.zip | busybox unzip -d /usr/share/nsis/Plugins/x86-unicode - SimpleSC.dll && \
    curl -L https://nsis.sourceforge.io/mediawiki/images/2/24/NSIS_Simple_Service_Plugin_ANSI_1.30.zip | busybox unzip -d /usr/share/nsis/Plugins/x86-ansi - SimpleSC.dll && \
    /usr/local/go/bin/go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest && \
    /usr/local/go/bin/go install github.com/swaggo/swag/cmd/swag@latest

ENV PATH=$PATH:/usr/local/go/bin:/usr/local/go10/bin:/root/go/bin

ENTRYPOINT make