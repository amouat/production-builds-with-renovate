# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM cgr.dev/chainguard/go:latest-dev@sha256:ceb74f4cdb7a5673f522e5b8b00af3f713b8446a4ce0c9c818d2e8fbeef448f5 AS builder
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
