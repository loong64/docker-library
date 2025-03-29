# Docker Official Images

使用 QEMU 在 GitHub Actions 上自动化构建 https://github.com/docker-library 仓库下的 `linux/loong64` 基础镜像。


## 镜像列表

| Architecture    | Arch      | OS/Arch       |
|-----------------|-----------|---------------|
| loongarch64     | loong64   | linux/loong64 |

[alpine](https://github.com/loong64/docker-debian-build/pkgs/container/alpine)

- ghcr.io/loong64/alpine:3
- ghcr.io/loong64/alpine:3.21

[debian](https://github.com/loong64/docker-debian-build/pkgs/container/debian)

- ghcr.io/loong64/debian:sid
- ghcr.io/loong64/debian:sid-slim
- ghcr.io/loong64/debian:trixie
- ghcr.io/loong64/debian:trixie-slim

[buildpack-deps](https://github.com/loong64/docker-library/pkgs/container/buildpack-deps)
- ghcr.io/loong64/buildpack-deps:trixie-curl
- ghcr.io/loong64/buildpack-deps:trixie-scm
- ghcr.io/loong64/buildpack-deps:trixie

[golang](https://github.com/loong64/docker-library/pkgs/container/golang)
- ghcr.io/loong64/golang:1.21-alpine
- ghcr.io/loong64/golang:1.21-trixie
- ghcr.io/loong64/golang:1.22-alpine
- ghcr.io/loong64/golang:1.22-trixie
- ghcr.io/loong64/golang:1.23-alpine
- ghcr.io/loong64/golang:1.23-trixie
- ghcr.io/loong64/golang:1.24-alpine
- ghcr.io/loong64/golang:1.24-trixie

[node](https://github.com/loong64/docker-library/pkgs/container/node)
- ghcr.io/loong64/node:18-alpine
- ghcr.io/loong64/node:18-trixie
- ghcr.io/loong64/node:18-trixie-slim
- ghcr.io/loong64/node:20-alpine
- ghcr.io/loong64/node:20-trixie
- ghcr.io/loong64/node:20-trixie-slim
- ghcr.io/loong64/node:22-alpine
- ghcr.io/loong64/node:22-trixie
- ghcr.io/loong64/node:22-trixie-slim
- ghcr.io/loong64/node:23-alpine
- ghcr.io/loong64/node:23-trixie
- ghcr.io/loong64/node:23-trixie-slim

[python](https://github.com/loong64/docker-library/pkgs/container/python)
- ghcr.io/loong64/python:3.9-alpine
- ghcr.io/loong64/python:3.9-trixie
- ghcr.io/loong64/python:3.9-slim-trixie
- ghcr.io/loong64/python:3.10-alpine
- ghcr.io/loong64/python:3.10-trixie
- ghcr.io/loong64/python:3.10-slim-trixie
- ghcr.io/loong64/python:3.11-alpine
- ghcr.io/loong64/python:3.11-trixie
- ghcr.io/loong64/python:3.11-slim-trixie
- ghcr.io/loong64/python:3.12-alpine
- ghcr.io/loong64/python:3.12-trixie
- ghcr.io/loong64/python:3.12-slim-trixie
- ghcr.io/loong64/python:3.13-alpine
- ghcr.io/loong64/python:3.13-trixie
- ghcr.io/loong64/python:3.13-slim-trixie

[redis](https://github.com/loong64/docker-library/pkgs/container/redis)
- ghcr.io/loong64/redis:7.2-alpine
- ghcr.io/loong64/redis:7.2-trixie
- ghcr.io/loong64/redis:7.4-alpine
- ghcr.io/loong64/redis:7.4-trixie

[postgres](https://github.com/loong64/docker-library/pkgs/container/postgres)
- ghcr.io/loong64/postgres:13-alpine
- ghcr.io/loong64/postgres:13-trixie
- ghcr.io/loong64/postgres:14-alpine
- ghcr.io/loong64/postgres:14-trixie
- ghcr.io/loong64/postgres:15-alpine
- ghcr.io/loong64/postgres:15-trixie
- ghcr.io/loong64/postgres:16-alpine
- ghcr.io/loong64/postgres:16-trixie
- ghcr.io/loong64/postgres:17-alpine
- ghcr.io/loong64/postgres:17-trixie


## 使用方法

```bash
# 在 linux/amd64 上可以使用 qemu 运行 linux/loong64 镜像
# 其他架构请自行安装 qemu-user-static
docker run --rm --privileged ghcr.io/loong64/qemu-user-static --reset -p yes
docker run --rm -it ghcr.io/loong64/debian:trixie-slim bash
```

## Docker Engine

Docker Engine for loong64，GitHub Actions 自动化构建 Docker Engine。

- https://github.com/loong64/docker-ce-packaging
