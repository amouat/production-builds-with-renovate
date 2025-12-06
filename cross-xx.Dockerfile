# syntax=docker/dockerfile:1
# Load cross-platform helper functions
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM cgr.dev/chainguard/go:latest-dev@sha256:b7d723ec0af894e092f9d9656fb94f294d15e3fc669e7bac146376d1360629f3 AS builder
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

FROM cgr.dev/chainguard/static:latest@sha256:1c785f2145250a80d2d71d2b026276f3358ef3543448500c72206d37ec4ece37
COPY --from=builder /work/hello /hello 

ENTRYPOINT ["/hello"]
