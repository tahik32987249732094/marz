#!/bin/bash
/marz/setup_env.sh
alembic upgrade head
echo $(cat /marz/.env)
nohup python main.py &>/dev/null &
nohup caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
