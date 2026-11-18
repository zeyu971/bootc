FROM quay.io/kairos/kairos-init:v0.17.3 AS kairos-init

FROM alpine:3.22
ARG VERSION=1.0.0

RUN --mount=type=bind,from=kairos-init,src=/kairos-init,dst=/kairos-init \
    /kairos-init -l debug -s install --version "${VERSION}" && \
    /kairos-init -l debug -s init --version "${VERSION}"
