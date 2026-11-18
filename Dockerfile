FROM quay.io/kairos/kairos-init:v0.17.3 AS kairos-init

FROM alpine:3.22
ARG VERSION=1.0.1

# 1. Installation des paquets Kairos (dont OpenRC)
RUN --mount=type=bind,from=kairos-init,src=/kairos-init,dst=/kairos-init \
    /kairos-init -l debug -s install --version "${VERSION}"

# 2. Personnalisations : clavier français
RUN apk add --no-cache kbd-bkeymaps && \
    mkdir -p /etc/keymap /etc/conf.d && \
    cp /usr/share/bkeymaps/fr/fr.bmap.gz /etc/keymap/fr.bmap.gz && \
    echo 'KEYMAP=/etc/keymap/fr.bmap.gz' > /etc/conf.d/loadkmap && \
    rc-update add loadkmap boot

# 3. Finalisation, toujours en dernier
RUN --mount=type=bind,from=kairos-init,src=/kairos-init,dst=/kairos-init \
    /kairos-init -l debug -s init --version "${VERSION}"