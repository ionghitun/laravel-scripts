#!/bin/bash
echo "*** Restarting... ***"

cd scripts/local
docker compose restart

echo "*** Restarted ***"
