# For testing versioning of images with private registry
FROM cgr.dev/chainguard.edu/go:1.25.3 AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:bf639cba19ba56329e6907ac26a7afcdde57a80b6aa66d5100da6883196e6b82
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
