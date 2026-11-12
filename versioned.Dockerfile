# For testing versioning of images with private registry
FROM cgr.dev/chainguard.edu/go:1.27.4@sha256:64a221c0fc2e4c060314722d730a133262f81f4bbdfdd1254a3de7c3c7a9b0c4 AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:d44809cee093b550944c1f666ff13301f92484bfdd2e53ecaac82b5b6f89647d
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
