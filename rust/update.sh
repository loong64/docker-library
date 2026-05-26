#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"
curl -sSL -O https://github.com/rust-lang/docker-rust/raw/refs/heads/master/versions.toml

python3 x.py update
