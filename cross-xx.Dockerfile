# syntax=docker/dockerfile:1
# Load cross-platform helper functions
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM cgr.dev/chainguard/go:latest-dev@sha256:d22e6f8bbef409464e7330c0058ba63fae61fd89c741182af997c9ba967b3ec0 AS builder
COPY --from=xx / /
RUN xx-apk add --no-cache zlib-dev
ARG TARGETOS
ARG TARGETARCH
WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

#RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -o hello ./cmd/server
RUN CGO_ENABLED=0 xx-go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:599c3cd7597b84aa149c4282beecc8c6d4e1cb5c95dc8d982e70cd0a2a9147a2
COPY --from=builder /work/hello /hello 

ENTRYPOINT ["/hello"]
