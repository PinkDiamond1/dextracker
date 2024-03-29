# Simple usage with a mounted data directory:
# > docker build -t dexd .
# > docker run -it -p 46657:46657 -p 46656:46656 -v ~/.dex:/dex/.dex dex dexd init
# > docker run -it -p 46657:46657 -p 46656:46656 -v ~/.dex:/dex/.dex dex dexd start
FROM golang:1.15-alpine AS build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3

# Set working directory for the build
WORKDIR /go/src/github.com/mydexchain/dex

# Add source files
COPY . .

RUN go version

# Install minimum necessary dependencies, build Chain SDK, remove packages
RUN apk add --no-cache $PACKAGES && \
    make install

# Final image
FROM alpine:edge

ENV DEX /dex

# Install ca-certificates
RUN apk add --update ca-certificates

RUN addgroup dex && \
    adduser -S -G dex dex -h "$DEX"

USER dex

WORKDIR $DEX

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/dexd /usr/bin/dexd

# Run dexd by default, omit entrypoint to ease using container with dexcli
CMD ["dexd"]
