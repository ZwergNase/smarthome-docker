FROM    oliverf/builder:latest

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

USER	root

RUN     addgroup --gid 1000 smartvisu && \
        adduser --system --disabled-password --ingroup smartvisu --uid 1000 smartvisu && \
        chmod og-wrx /home/smartvisu

WORKDIR /home/smartvisu

COPY    --chown=smartvisu:smartvisu update_internal.sh ./update.sh

ENTRYPOINT ["/bin/bash", "update.sh"]
