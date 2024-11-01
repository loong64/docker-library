#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

variants=("trixie" "trixie-slim")

versions=( */ )

versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
    fullVersion=$(curl -s https://nodejs.org/download/release/index.json | jq -r '.[] | .version' | grep -E '^v'"${version}" | head -n 1)
    if [ -z "$fullVersion" ]; then
        echo "Node.js version not found"
        exit 0
    fi
    for variant in "${variants[@]}"; do
        sed -i "s/ENV NODE_VERSION .*/ENV NODE_VERSION $fullVersion/g" "$version/$variant/Dockerfile"
    done
done