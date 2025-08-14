# Docker Official Images

使用 QEMU 在 GitHub Actions 上自动化构建 https://github.com/docker-library 仓库下的 `linux/loong64` 基础镜像。

| Architecture    | Arch      | OS/Arch       |
|-----------------|-----------|---------------|
| loongarch64     | loong64   | linux/loong64 |

## Installing emulators

```bash
# 在 linux/amd64, linux/arm64 或其他非 linux/loong64 上可以使用 qemu 运行 linux/loong64 镜像

docker run --privileged --rm ghcr.io/loong64/binfmt --install all
docker run --rm -it ghcr.io/loong64/debian:trixie-slim bash
```

## Docker Engine

Docker Engine for loong64，GitHub Actions 自动化构建 Docker Engine。

- https://github.com/loong64/docker-ce-packaging


## 镜像列表

| Name                                                     | Tag                  | Pull Command                                             |
| -------------------------------------------------------- | -------------------- | -------------------------------------------------------- |
| [alpine](https://ghcr.io/loong64/alpine)                 | `3.21`               | `docker pull ghcr.io/loong64/alpine:3.21`                |
| [alpine](https://ghcr.io/loong64/alpine)                 | `3.22`               | `docker pull ghcr.io/loong64/alpine:3.22`                |
| [debian](https://ghcr.io/loong64/debian)                 | `trixie`             | `docker pull ghcr.io/loong64/debian:trixie`              |
| [debian](https://ghcr.io/loong64/debian)                 | `forky`              | `docker pull ghcr.io/loong64/debian:forky`               |
| [debian](https://ghcr.io/loong64/debian)                 | `trixie-slim`        | `docker pull ghcr.io/loong64/debian:trixie-slim`         |
| [debian](https://ghcr.io/loong64/debian)                 | `forky-slim`         | `docker pull ghcr.io/loong64/debian:forky-slim`          |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `trixie`             | `docker pull ghcr.io/loong64/buildpack-deps:trixie`      |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `forky`              | `docker pull ghcr.io/loong64/buildpack-deps:forky`       |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `trixie-scm`         | `docker pull ghcr.io/loong64/buildpack-deps:trixie-scm`  |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `forky-scm`          | `docker pull ghcr.io/loong64/buildpack-deps:forky-scm`   |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `trixie-curl`        | `docker pull ghcr.io/loong64/buildpack-deps:trixie-curl` |
| [buildpack-deps](https://ghcr.io/loong64/buildpack-deps) | `forky-curl`         | `docker pull ghcr.io/loong64/buildpack-deps:forky-curl`  |
| [golang](https://ghcr.io/loong64/golang)                 | `1.23-alpine`        | `docker pull ghcr.io/loong64/golang:1.23-alpine`         |
| [golang](https://ghcr.io/loong64/golang)                 | `1.23-trixie`        | `docker pull ghcr.io/loong64/golang:1.23-trixie`         |
| [golang](https://ghcr.io/loong64/golang)                 | `1.24-alpine`        | `docker pull ghcr.io/loong64/golang:1.24-alpine`         |
| [golang](https://ghcr.io/loong64/golang)                 | `1.24-trixie`        | `docker pull ghcr.io/loong64/golang:1.24-trixie`         |
| [node](https://ghcr.io/loong64/node)                     | `18-alpine`          | `docker pull ghcr.io/loong64/node:18-alpine`             |
| [node](https://ghcr.io/loong64/node)                     | `18-trixie`          | `docker pull ghcr.io/loong64/node:18-trixie`             |
| [node](https://ghcr.io/loong64/node)                     | `18-trixie-slim`     | `docker pull ghcr.io/loong64/node:18-trixie-slim`        |
| [node](https://ghcr.io/loong64/node)                     | `20-alpine`          | `docker pull ghcr.io/loong64/node:20-alpine`             |
| [node](https://ghcr.io/loong64/node)                     | `20-trixie`          | `docker pull ghcr.io/loong64/node:20-trixie`             |
| [node](https://ghcr.io/loong64/node)                     | `20-trixie-slim`     | `docker pull ghcr.io/loong64/node:20-trixie-slim`        |
| [node](https://ghcr.io/loong64/node)                     | `22-alpine`          | `docker pull ghcr.io/loong64/node:22-alpine`             |
| [node](https://ghcr.io/loong64/node)                     | `22-trixie`          | `docker pull ghcr.io/loong64/node:22-trixie`             |
| [node](https://ghcr.io/loong64/node)                     | `22-trixie-slim`     | `docker pull ghcr.io/loong64/node:22-trixie-slim`        |
| [node](https://ghcr.io/loong64/node)                     | `23-alpine`          | `docker pull ghcr.io/loong64/node:23-alpine`             |
| [node](https://ghcr.io/loong64/node)                     | `23-trixie`          | `docker pull ghcr.io/loong64/node:23-trixie`             |
| [node](https://ghcr.io/loong64/node)                     | `23-trixie-slim`     | `docker pull ghcr.io/loong64/node:23-trixie-slim`        |
| [node](https://ghcr.io/loong64/node)                     | `24-alpine`          | `docker pull ghcr.io/loong64/node:24-alpine`             |
| [node](https://ghcr.io/loong64/node)                     | `24-trixie`          | `docker pull ghcr.io/loong64/node:24-trixie`             |
| [node](https://ghcr.io/loong64/node)                     | `24-trixie-slim`     | `docker pull ghcr.io/loong64/node:24-trixie-slim`        |
| [python](https://ghcr.io/loong64/python)                 | `3.9-alpine`         | `docker pull ghcr.io/loong64/python:3.9-alpine`          |
| [python](https://ghcr.io/loong64/python)                 | `3.9-trixie`         | `docker pull ghcr.io/loong64/python:3.9-trixie`          |
| [python](https://ghcr.io/loong64/python)                 | `3.9-slim-trixie`    | `docker pull ghcr.io/loong64/python:3.9-slim-trixie`     |
| [python](https://ghcr.io/loong64/python)                 | `3.10-alpine`        | `docker pull ghcr.io/loong64/python:3.10-alpine`         |
| [python](https://ghcr.io/loong64/python)                 | `3.10-trixie`        | `docker pull ghcr.io/loong64/python:3.10-trixie`         |
| [python](https://ghcr.io/loong64/python)                 | `3.10-slim-trixie`   | `docker pull ghcr.io/loong64/python:3.10-slim-trixie`    |
| [python](https://ghcr.io/loong64/python)                 | `3.11-alpine`        | `docker pull ghcr.io/loong64/python:3.11-alpine`         |
| [python](https://ghcr.io/loong64/python)                 | `3.11-trixie`        | `docker pull ghcr.io/loong64/python:3.11-trixie`         |
| [python](https://ghcr.io/loong64/python)                 | `3.11-slim-trixie`   | `docker pull ghcr.io/loong64/python:3.11-slim-trixie`    |
| [python](https://ghcr.io/loong64/python)                 | `3.12-alpine`        | `docker pull ghcr.io/loong64/python:3.12-alpine`         |
| [python](https://ghcr.io/loong64/python)                 | `3.12-trixie`        | `docker pull ghcr.io/loong64/python:3.12-trixie`         |
| [python](https://ghcr.io/loong64/python)                 | `3.12-slim-trixie`   | `docker pull ghcr.io/loong64/python:3.12-slim-trixie`    |
| [python](https://ghcr.io/loong64/python)                 | `3.13-alpine`        | `docker pull ghcr.io/loong64/python:3.13-alpine`         |
| [python](https://ghcr.io/loong64/python)                 | `3.13-trixie`        | `docker pull ghcr.io/loong64/python:3.13-trixie`         |
| [python](https://ghcr.io/loong64/python)                 | `3.13-slim-trixie`   | `docker pull ghcr.io/loong64/python:3.13-slim-trixie`    |
| [redis](https://ghcr.io/loong64/redis)                   | `7.2-alpine`         | `docker pull ghcr.io/loong64/redis:7.2-alpine`           |
| [redis](https://ghcr.io/loong64/redis)                   | `7.2-trixie`         | `docker pull ghcr.io/loong64/redis:7.2-trixie`           |
| [redis](https://ghcr.io/loong64/redis)                   | `7.4-alpine`         | `docker pull ghcr.io/loong64/redis:7.4-alpine`           |
| [redis](https://ghcr.io/loong64/redis)                   | `7.4-trixie`         | `docker pull ghcr.io/loong64/redis:7.4-trixie`           |
| [php](https://ghcr.io/loong64/php)                       | `8.1-cli-alpine3.21` | `docker pull ghcr.io/loong64/php:8.1-cli-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.1-fpm-alpine3.21` | `docker pull ghcr.io/loong64/php:8.1-fpm-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.1-zts-alpine3.21` | `docker pull ghcr.io/loong64/php:8.1-zts-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.2-cli-alpine3.21` | `docker pull ghcr.io/loong64/php:8.2-cli-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.2-fpm-alpine3.21` | `docker pull ghcr.io/loong64/php:8.2-fpm-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.2-zts-alpine3.21` | `docker pull ghcr.io/loong64/php:8.2-zts-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.3-cli-alpine3.21` | `docker pull ghcr.io/loong64/php:8.3-cli-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.3-fpm-alpine3.21` | `docker pull ghcr.io/loong64/php:8.3-fpm-alpine3.21`     |
| [php](https://ghcr.io/loong64/php)                       | `8.3-zts-alpine3.21` | `docker pull ghcr.io/loong64/php:8.3-zts-alpine3.21`     |
| [postgres](https://ghcr.io/loong64/postgres)             | `13-alpine`          | `docker pull ghcr.io/loong64/postgres:13-alpine`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `13-trixie`          | `docker pull ghcr.io/loong64/postgres:13-trixie`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `14-alpine`          | `docker pull ghcr.io/loong64/postgres:14-alpine`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `14-trixie`          | `docker pull ghcr.io/loong64/postgres:14-trixie`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `15-alpine`          | `docker pull ghcr.io/loong64/postgres:15-alpine`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `15-trixie`          | `docker pull ghcr.io/loong64/postgres:15-trixie`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `16-alpine`          | `docker pull ghcr.io/loong64/postgres:16-alpine`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `16-trixie`          | `docker pull ghcr.io/loong64/postgres:16-trixie`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `17-alpine`          | `docker pull ghcr.io/loong64/postgres:17-alpine`         |
| [postgres](https://ghcr.io/loong64/postgres)             | `17-trixie`          | `docker pull ghcr.io/loong64/postgres:17-trixie`         |
| [mariadb](https://ghcr.io/loong64/mariadb)               | `11.4`               | `docker pull ghcr.io/loong64/mariadb:11.4`               |
| [mariadb](https://ghcr.io/loong64/mariadb)               | `11.4-trixie`        | `docker pull ghcr.io/loong64/mariadb:11.4-trixie`        |
| [mariadb](https://ghcr.io/loong64/mariadb)               | `11.8-rc`            | `docker pull ghcr.io/loong64/mariadb:11.8-rc`            |
| [mariadb](https://ghcr.io/loong64/mariadb)               | `11.8-trixie-rc`     | `docker pull ghcr.io/loong64/mariadb:11.8-trixie-rc`     |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.26-alpine`        | `docker pull ghcr.io/loong64/nginx:1.26-alpine`          |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.26-trixie`        | `docker pull ghcr.io/loong64/nginx:1.26-trixie`          |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.27-alpine`        | `docker pull ghcr.io/loong64/nginx:1.27-alpine`          |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.27-trixie`        | `docker pull ghcr.io/loong64/nginx:1.27-trixie`          |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.28-alpine`        | `docker pull ghcr.io/loong64/nginx:1.28-alpine`          |
| [nginx](https://ghcr.io/loong64/nginx)                   | `1.28-trixie`        | `docker pull ghcr.io/loong64/nginx:1.28-trixie`          |
| [pgvector](https://ghcr.io/loong64/pgvector)             | `pg13`               | `docker pull ghcr.io/loong64/pgvector:pg13`              |
| [pgvector](https://ghcr.io/loong64/pgvector)             | `pg14`               | `docker pull ghcr.io/loong64/pgvector:pg14`              |
| [pgvector](https://ghcr.io/loong64/pgvector)             | `pg15`               | `docker pull ghcr.io/loong64/pgvector:pg15`              |
| [pgvector](https://ghcr.io/loong64/pgvector)             | `pg16`               | `docker pull ghcr.io/loong64/pgvector:pg16`              |
| [pgvector](https://ghcr.io/loong64/pgvector)             | `pg17`               | `docker pull ghcr.io/loong64/pgvector:pg17`              |
| [squid](https://ghcr.io/loong64/squid)                   | `latest`             | `docker pull ghcr.io/loong64/squid:latest`               |
| [busybox](https://ghcr.io/loong64/busybox)               | `1.37.0-glibc`       | `docker pull ghcr.io/loong64/busybox:1.37.0-glibc`       |
| [busybox](https://ghcr.io/loong64/busybox)               | `1.37.0-musl`        | `docker pull ghcr.io/loong64/busybox:1.37.0-musl`        |