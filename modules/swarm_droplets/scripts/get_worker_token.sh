#!/bin/bash
set -e

MANAGER_IP="$1"
PRIVATE_KEY_PATH="$2"

TOKEN=$(ssh -o StrictHostKeyChecking=no -i "$PRIVATE_KEY_PATH" root@"$MANAGER_IP" "docker swarm join-token -q worker")

# Output JSON
echo "{\"token\": \"$TOKEN\"}"
