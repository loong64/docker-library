#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

variants=("trixie" "trixie-slim" "forky" "forky-slim" "alpine3.21" "alpine3.22")

versions=( */ )

versions=( "${versions[@]%/}" )

yarnVersion="$(curl -sSL --compressed https://yarnpkg.com/latest-version)"

for version in "${versions[@]}"; do
    fullVersion=$(curl -s https://nodejs.org/download/release/index.json | jq -r '.[] | .version' | grep -E '^v'"${version}" | head -n 1)
    if [ -z "$fullVersion" ]; then
        echo "Node.js version not found"
        exit 0
    fi
    if [ -z "$yarnVersion" ]; then
        echo "Yarn version not found"
        exit 0
    fi
    echo "$version: ${fullVersion#v}"
    for variant in "${variants[@]}"; do
        if [ ! -f "$version/$variant/Dockerfile" ]; then
            continue
        fi
        echo "processing $version/$variant ..."
        sed -i "s/ENV NODE_VERSION=.*/ENV NODE_VERSION=${fullVersion#v}/g" "$version/$variant/Dockerfile"
        sed -i "s/ENV YARN_VERSION=.*/ENV YARN_VERSION=${yarnVersion}/g" "$version/$variant/Dockerfile"
    done
done