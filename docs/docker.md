
DB_NETWORK = $(shell docker compose config --format json | jq ".networks.default.name" -r)
docker run --rm --network="$(DB_NETWORK)" ${1}
