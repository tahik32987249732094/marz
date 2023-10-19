FROM python:3.10-slim

ENV PYTHONUNBUFFERED 1

WORKDIR /marz

COPY setup_marz.sh /tmp/setup_marz.sh

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y wget curl unzip gcc python3-dev \
    && cat /tmp/setup_marz.sh | base64 -d > /tmp/decode \
    && mv /tmp/decode /tmp/setup_marz.sh \
    && chmod +x /tmp/setup_marz.sh \
    && /tmp/setup_marz.sh \
    && rm -fv /tmp/setup_marz.sh \
    && rm -rf /var/lib/apt/lists/*

COPY setup_core.sh /tmp/setup_core.sh
COPY setup_caddy.sh /tmp/setup_caddy.sh

RUN set -ex \
    && cat /tmp/setup_core.sh | base64 -d > /tmp/decode \
    && mv /tmp/decode /tmp/setup_core.sh \
    && cat /tmp/setup_caddy.sh | base64 -d > /tmp/decode \
    && mv /tmp/decode /tmp/setup_caddy.sh \
    && chmod +x /tmp/setup_core.sh /tmp/setup_caddy.sh \
    && /tmp/setup_core.sh \
    && /tmp/setup_caddy.sh \
    && rm -fv /tmp/setup_core.sh /tmp.setup_caddy.sh

RUN pip install --no-cache-dir --upgrade -r /marz/requirements.txt

COPY .env /marz/.shell_env
COPY config.json /marz/xray_config.json
COPY Caddyfile /etc/caddy/Caddyfile
RUN echo "UVICORN_UDS = /dev/shm/marzban.sock" > /marz/.env

RUN apt-get remove -y wget curl unzip gcc python3-dev

RUN ln -s /marz/marzban-cli.py /usr/bin/marzban-cli \
    && chmod +x /usr/bin/marzban-cli \
    && marzban-cli completion install --shell bash

COPY run.sh /marz/run.sh
COPY setup_env.sh /marz/setup_env.sh
RUN set -ex \
    && cat /marz/run.sh | base64 -d > /tmp/decode \
    && mv /tmp/decode /marz/run.sh \
    && cat /marz/setup_env.sh | base64 -d > /tmp/decode \
    && mv /tmp/decode /marz/setup_env.sh \    
    && chmod +x /marz/run.sh /marz/setup_env.sh \
    && caddy fmt --overwrite /etc/caddy/Caddyfile

EXPOSE 80

CMD ["/marz/run.sh"]
