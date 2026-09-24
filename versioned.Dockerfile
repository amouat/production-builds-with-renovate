# For testing versioning of images with private registry
FROM cgr.dev/chainguard.edu/go:1.27.1@sha256:37b28ceb85fccffa2b19f77b39b0ba3171fcfde00a5006546c7f9a872febebda AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:d44809cee093b550944c1f666ff13301f92484bfdd2e53ecaac82b5b6f89647d
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
