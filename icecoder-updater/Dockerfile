FROM    oliverf/builder:latest

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

USER	root

RUN     addgroup --gid 1000 icecoder && \
        adduser --system --disabled-password --ingroup icecoder --uid 1000 icecoder && \
        chmod og-wrx /home/icecoder

WORKDIR /home/icecoder

COPY    --chown=icecoder:icecoder update_internal.sh ./update.sh

ENTRYPOINT ["/bin/bash", "update.sh"]
