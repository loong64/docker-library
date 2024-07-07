#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ghcr.io/loong64/buildpack-deps:trixie-scm AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.21.12

RUN set -eux; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	case "$arch" in \
		'amd64') \
			url='https://dl.google.com/go/go1.21.12.linux-amd64.tar.gz'; \
			sha256='121ab58632787e18ae0caa8ae285b581f9470d0f6b3defde9e1600e211f583c5'; \
			;; \
		'armhf') \
			url='https://dl.google.com/go/go1.21.12.linux-armv6l.tar.gz'; \
			sha256='04148803fdee283c0259bc971eddefa4134dc2695a3de01aebe17787bf4705b6'; \
			;; \
		'arm64') \
			url='https://dl.google.com/go/go1.21.12.linux-arm64.tar.gz'; \
			sha256='94cb3ec4a1e08a00da55c33e63f725be91f10ba743907b5615ef34e54675ba2e'; \
			;; \
		'i386') \
			url='https://dl.google.com/go/go1.21.12.linux-386.tar.gz'; \
			sha256='c1afee9e774d280211ee31437f32cdda8cbc506c1475e16bd3a8fd1ebf5c4b1d'; \
			;; \
		'loong64') \
			url='https://dl.google.com/go/go1.21.12.linux-loong64.tar.gz'; \
			sha256='c7b8ce7c79714c0320085585a0ae2c222a19dbf75198de446e32babfad11aa6e'; \
			;; \
		'mips64el') \
			url='https://dl.google.com/go/go1.21.12.linux-mips64le.tar.gz'; \
			sha256='45dc06870a4aa60f434d766c911533c943ac01f80a4dd3133a47285e3d81130f'; \
			;; \
		'ppc64el') \
			url='https://dl.google.com/go/go1.21.12.linux-ppc64le.tar.gz'; \
			sha256='46b2dae42132fd697c6c34a6bee3df8e3288b9f01143eafbcc452b0d2a35b205'; \
			;; \
		'riscv64') \
			url='https://dl.google.com/go/go1.21.12.linux-riscv64.tar.gz'; \
			sha256='17db3a49b6443c1df893b48b40c8e6de06064be4c203285f4010254be842e5eb'; \
			;; \
		's390x') \
			url='https://dl.google.com/go/go1.21.12.linux-s390x.tar.gz'; \
			sha256='3746ddaafedb9f1744a647c51b9c4454b82a699de0f6dffbb2f3cb698a846482'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	\
	wget -O go.tgz.asc "$url.asc"; \
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	\
# https://github.com/golang/go/issues/14739#issuecomment-324767697
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
# https://www.google.com/linuxrepositories/
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC  EC91 7721 F63B D38B 4796'; \
# let's also fetch the specific subkey of that key explicitly that we expect "go.tgz.asc" to be signed by, just to make sure we definitely have it
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys '2F52 8D36 D67B 69ED F998  D857 78BD 6547 3CB3 BD13'; \
	gpg --batch --verify go.tgz.asc go.tgz; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" go.tgz.asc; \
	\
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
# save the timestamp from the tarball so we can restore it for reproducibility, if necessary (see below)
	SOURCE_DATE_EPOCH="$(stat -c '%Y' /usr/local/go)"; \
	export SOURCE_DATE_EPOCH; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822; \
	\
	if [ "$arch" = 'armhf' ]; then \
		[ -s /usr/local/go/go.env ]; \
		before="$(go env GOARM)"; [ "$before" != '7' ]; \
		{ \
			echo; \
			echo '# https://github.com/docker-library/golang/issues/494'; \
			echo 'GOARM=7'; \
		} >> /usr/local/go/go.env; \
		after="$(go env GOARM)"; [ "$after" = '7' ]; \
# (re-)clamp timestamp for reproducibility (allows "COPY --link" to be more clever/useful)
		date="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
		touch -t "$date" /usr/local/go/go.env /usr/local/go; \
	fi; \
	\
# smoke test
	go version; \
# make sure our reproducibile timestamp is probably still correct (best-effort inline reproducibility test)
	epoch="$(stat -c '%Y' /usr/local/go)"; \
	[ "$SOURCE_DATE_EPOCH" = "$epoch" ]

FROM ghcr.io/loong64/buildpack-deps:trixie-scm

# install cgo-related dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	; \
	rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.21.12

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=build --link /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
