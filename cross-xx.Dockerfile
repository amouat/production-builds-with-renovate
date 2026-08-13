# syntax=docker/dockerfile:1@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# Load cross-platform helper functions
FROM --platform=$BUILDPLATFORM tonistiigi/xx@sha256:c64defb9ed5a91eacb37f96ccc3d4cd72521c4bd18d5442905b95e2226b0e707 AS xx

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

FROM cgr.dev/chainguard/static:latest@sha256:1c785f2145250a80d2d71d2b026276f3358ef3543448500c72206d37ec4ece37
COPY --from=builder /work/hello /hello 

ENTRYPOINT ["/hello"]
