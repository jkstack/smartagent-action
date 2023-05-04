FROM debian:stable-slim

ARG GO_VERSION=1.20.4
ARG TARGETPLATFORM

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl git make fakeroot nsis dos2unix && \
    apt-get install -y busybox unzip && \
    PLATFORM=`basename $TARGETPLATFORM` && \
    curl -L https://go.dev/dl/go$GO_VERSION.linux-$PLATFORM.tar.gz|tar -xz -C /usr/local && \
    curl -L https://nsis.sourceforge.io/mediawiki/images/e/ef/NSIS_Simple_Service_Plugin_Unicode_1.30.zip | busybox unzip -d /usr/share/nsis/Plugins/x86-unicode - SimpleSC.dll && \
    curl -L https://nsis.sourceforge.io/mediawiki/images/2/24/NSIS_Simple_Service_Plugin_ANSI_1.30.zip | busybox unzip -d /usr/share/nsis/Plugins/x86-ansi - SimpleSC.dll && \
    /usr/local/go/bin/go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest && \
    /usr/local/go/bin/go install github.com/swaggo/swag/cmd/swag@latest

ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin

ENTRYPOINT make