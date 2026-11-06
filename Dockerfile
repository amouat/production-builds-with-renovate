# syntax=docker/dockerfile:1
FROM cgr.dev/chainguard/go:latest-dev@sha256:ed70318f7b4f2e4a82e1dbc363f7a13be3a5805081f86ed9d1ec02d2694c222f AS builder

WORKDIR /work

COPY go.mod /work/
COPY cmd /work/cmd
COPY internal /work/internal

RUN CGO_ENABLED=0 go build -o hello ./cmd/server

FROM cgr.dev/chainguard/static:latest@sha256:d44809cee093b550944c1f666ff13301f92484bfdd2e53ecaac82b5b6f89647d
COPY --from=builder /work/hello /hello

ENTRYPOINT ["/hello"]
