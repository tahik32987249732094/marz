FROM python:3.10-slim

ENV PYTHONUNBUFFERED 1

ARG SUDO_USERNAME
ARG SUDO_PASSWORD
ARG TELEGRAM_API_TOKEN
ARG TELEGRAM_ADMIN_ID

WORKDIR /marz

COPY setup_marz.sh /tmp/setup_marz.sh

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y wget curl unzip gcc python3-dev \
    && chmod +x /tmp/setup_marz.sh \
    && /tmp/setup_marz.sh \
    && rm -fv /tmp/setup_marz.sh \
    && rm -rf /var/lib/apt/lists/*

COPY setup_core.sh /tmp/setup_core.sh
COPY setup_caddy.sh /tmp/setup_caddy.sh

RUN set -ex \
    && chmod +x /tmp/setup_core.sh /tmp/setup_caddy.sh \
    && /tmp/setup_core.sh \
    && /tmp/setup_caddy.sh \
    && rm -fv /tmp/setup_core.sh /tmp.setup_caddy.sh

RUN pip install --no-cache-dir --upgrade -r /marz/requirements.txt

COPY .env /marz/.env
COPY config.json /marz/xray_config.json
COPY Caddyfile /etc/caddy/Caddyfile

RUN apt-get remove -y wget curl unzip gcc python3-dev

COPY setup_env.sh /marz/setup_env.sh
RUN set -ex \
    && chmod +x /marz/setup_env.sh \
    && /marz/setup_env.sh

RUN ln -s /marz/marzban-cli.py /usr/bin/marzban-cli \
    && chmod +x /usr/bin/marzban-cli \
    && marzban-cli completion install --shell bash

COPY run.sh /marz/run.sh
RUN set -ex \
    && chmod +x /marz/run.sh /marz/setup_env.sh \
    && /marz/setup_env.sh \
    && caddy fmt --overwrite /etc/caddy/Caddyfile

EXPOSE 80

CMD ["/marz/run.sh"]