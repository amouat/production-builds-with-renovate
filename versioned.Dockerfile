# For testing versioning of images with private registry
FROM cgr.dev/chainguard.edu/go:1.25.3 AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:599c3cd7597b84aa149c4282beecc8c6d4e1cb5c95dc8d982e70cd0a2a9147a2
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
