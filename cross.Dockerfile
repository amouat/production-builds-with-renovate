# syntax=docker/dockerfile:1@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183
FROM --platform=$BUILDPLATFORM cgr.dev/chainguard/go:latest-dev@sha256:d22e6f8bbef409464e7330c0058ba63fae61fd89c741182af997c9ba967b3ec0 AS builder
ARG TARGETOS
ARG TARGETARCH
WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:1c785f2145250a80d2d71d2b026276f3358ef3543448500c72206d37ec4ece37
COPY --from=builder /work/hello /hello 

ENTRYPOINT ["/hello"]
