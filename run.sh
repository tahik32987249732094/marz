#!/bin/bash
/marz/setup_env.sh
echo $(cat /marz/.env)
alembic upgrade head
nohup python main.py &>/dev/null &
nohup caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
