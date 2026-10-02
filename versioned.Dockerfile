# For testing versioning of images with private registry
FROM cgr.dev/chainguard.edu/go:1.25.3 AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:fe55470f22d3259488d9d3739168d8f04da67755f0b69382bc26eda4a7d3d327
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
