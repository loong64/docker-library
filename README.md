# Docker Official Images

使用 QEMU 在 GitHub Actions 上自动化构建 https://github.com/docker-library 仓库下的 `linux/loong64` 基础镜像。


## 镜像列表

| Architecture    | Arch      | OS/Arch       |
|-----------------|-----------|---------------|
| loongarch64     | loong64   | linux/loong64 |

[debian](https://github.com/loong64/docker-debian-build/pkgs/container/debian)

- ghcr.io/loong64/debian:sid
- ghcr.io/loong64/debian:sid-slim
- ghcr.io/loong64/debian:trixie
- ghcr.io/loong64/debian:trixie-slim

[buildpack-deps](https://github.com/loong64/docker-library/pkgs/container/buildpack-deps)
- ghcr.io/loong64/buildpack-deps:sid-curl
- ghcr.io/loong64/buildpack-deps:sid-scm
- ghcr.io/loong64/buildpack-deps:trixie-curl
- ghcr.io/loong64/buildpack-deps:trixie-scm

[golang](https://github.com/loong64/docker-library/pkgs/container/golang)
- ghcr.io/loong64/golang:1.21
- ghcr.io/loong64/golang:1.21-sid
- ghcr.io/loong64/golang:1.21-trixie
- ghcr.io/loong64/golang:1.22
- ghcr.io/loong64/golang:1.22-sid
- ghcr.io/loong64/golang:1.22-trixie

[python](https://github.com/loong64/docker-library/pkgs/container/python)
- ghcr.io/loong64/python:3.9
- ghcr.io/loong64/python:3.9-sid
- ghcr.io/loong64/python:3.9-trixie
- ghcr.io/loong64/python:3.9-slim-sid
- ghcr.io/loong64/python:3.9-slim-trixie
- ghcr.io/loong64/python:3.10
- ghcr.io/loong64/python:3.10-sid
- ghcr.io/loong64/python:3.10-trixie
- ghcr.io/loong64/python:3.10-slim-sid
- ghcr.io/loong64/python:3.10-slim-trixie
- ghcr.io/loong64/python:3.11
- ghcr.io/loong64/python:3.11-sid
- ghcr.io/loong64/python:3.11-trixie
- ghcr.io/loong64/python:3.11-slim-sid
- ghcr.io/loong64/python:3.11-slim-trixie
- ghcr.io/loong64/python:3.12
- ghcr.io/loong64/python:3.12-sid
- ghcr.io/loong64/python:3.12-trixie
- ghcr.io/loong64/python:3.12-slim-sid
- ghcr.io/loong64/python:3.12-slim-trixie
- ghcr.io/loong64/python:3.13-rc
- ghcr.io/loong64/python:3.13-rc-sid
- ghcr.io/loong64/python:3.13-rc-trixie
- ghcr.io/loong64/python:3.13-rc-slim-sid
- ghcr.io/loong64/python:3.13-rc-slim-trixie

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