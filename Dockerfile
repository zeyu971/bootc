FROM quay.io/kairos/kairos-init:v0.17.3 AS kairos-init

FROM alpine:3.22
ARG VERSION=1.0.1

# Personnalisations : clavier français
RUN apk add --no-cache kbd-bkeymaps && \
    mkdir -p /etc/keymap && \
    cp /usr/share/bkeymaps/fr/fr.bmap.gz /etc/keymap/fr.bmap.gz && \
    echo 'KEYMAP=/etc/keymap/fr.bmap.gz' > /etc/conf.d/loadkmap && \
    rc-update add loadkmap boot

RUN --mount=type=bind,from=kairos-init,src=/kairos-init,dst=/kairos-init \
    /kairos-init -l debug -s install --version "${VERSION}" && \
    /kairos-init -l debug -s init --version "${VERSION}"
