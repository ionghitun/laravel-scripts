#!/bin/bash
echo "Started restart"

cd scripts/local
docker compose restart

echo "Finished restart"
