#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ghcr.io/loong64/alpine:3.21 AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.24rc1

RUN set -eux; \
	now="$(date '+%s')"; \
	apk add --no-cache --virtual .fetch-deps \
		ca-certificates \
		gnupg \
# busybox's "tar" doesn't handle directory mtime correctly, so our SOURCE_DATE_EPOCH lookup doesn't work (the mtime of "/usr/local/go" always ends up being the extraction timestamp)
		tar \
	; \
	arch="$(apk --print-arch)"; \
	url=; \
	case "$arch" in \
		'x86_64') \
			url='https://dl.google.com/go/go1.24rc1.linux-amd64.tar.gz'; \
			sha256='706c3810c0826dd43bb6d5274c5fa4f644488274533a9bb1f9b13a0e302afcc6'; \
			;; \
		'armhf') \
			url='https://dl.google.com/go/go1.24rc1.linux-armv6l.tar.gz'; \
			sha256='8b1bd52e292626a2dae8a5d684590380bd3c6af923a7504c0fe9f9e51abbfe1e'; \
			;; \
		'armv7') \
			url='https://dl.google.com/go/go1.24rc1.linux-armv6l.tar.gz'; \
			sha256='8b1bd52e292626a2dae8a5d684590380bd3c6af923a7504c0fe9f9e51abbfe1e'; \
			;; \
		'aarch64') \
			url='https://dl.google.com/go/go1.24rc1.linux-arm64.tar.gz'; \
			sha256='febc01e97564c3851f96a778bd31f9b7631517f71e7bdf15baeb47c84d735a18'; \
			;; \
		'x86') \
			url='https://dl.google.com/go/go1.24rc1.linux-386.tar.gz'; \
			sha256='f8332a537d99504cca6d1a706a34aad74051dadcb098dc5b87de1733e24db3b7'; \
			;; \
		'loongarch64') \
			url='https://dl.google.com/go/go1.24rc1.linux-loong64.tar.gz'; \
			sha256='54631f57f99e7807324cbe9e3a4133e41edbcf404f885993e5375a7049f4bb5e'; \
			;; \
		'ppc64le') \
			url='https://dl.google.com/go/go1.24rc1.linux-ppc64le.tar.gz'; \
			sha256='492eca7616fe51194886d5ae3a782d97559d7e8ba7e51ccb23fa1b32c79d96e9'; \
			;; \
		'riscv64') \
			url='https://dl.google.com/go/go1.24rc1.linux-riscv64.tar.gz'; \
			sha256='5cd2bc49913b0661a2f30d88fb80cd600477f66fa44b2d3d7002ce7fa7bffb91'; \
			;; \
		's390x') \
			url='https://dl.google.com/go/go1.24rc1.linux-s390x.tar.gz'; \
			sha256='13331e1c63c944b86602944945a2b87c88c002deaeea971b9930fd1d3b3e7a2c'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	\
	wget -O go.tgz.asc "$url.asc"; \
	wget -O go.tgz "$url"; \
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
	touchy="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822; \
# sanity check (detected value should be older than our wall clock)
	[ "$SOURCE_DATE_EPOCH" -lt "$now" ]; \
	\
	if [ "$arch" = 'armv7' ]; then \
		[ -s /usr/local/go/go.env ]; \
		before="$(go env GOARM)"; [ "$before" != '7' ]; \
		{ \
			echo; \
			echo '# https://github.com/docker-library/golang/issues/494'; \
			echo 'GOARM=7'; \
		} >> /usr/local/go/go.env; \
		after="$(go env GOARM)"; [ "$after" = '7' ]; \
# (re-)clamp timestamp for reproducibility (allows "COPY --link" to be more clever/useful)
		touch -t "$touchy" /usr/local/go/go.env /usr/local/go; \
	fi; \
	\
# ideally at this point, we would just "COPY --link ... /usr/local/go/ /usr/local/go/" but BuildKit insists on creating the parent directories (perhaps related to https://github.com/opencontainers/image-spec/pull/970), and does so with unreproducible timestamps, so we instead create a whole new "directory tree" that we can "COPY --link" to accomplish what we want
	mkdir /target /target/usr /target/usr/local; \
	mv -vT /usr/local/go /target/usr/local/go; \
	ln -svfT /target/usr/local/go /usr/local/go; \
	touch -t "$touchy" /target/usr/local /target/usr /target; \
	\
	apk del --no-network .fetch-deps; \
	\
# smoke test
	go version; \
# make sure our reproducibile timestamp is probably still correct (best-effort inline reproducibility test)
	epoch="$(stat -c '%Y' /target/usr/local/go)"; \
	[ "$SOURCE_DATE_EPOCH" = "$epoch" ]; \
	find /target -newer /target/usr/local/go -exec sh -c 'ls -ld "$@" && exit "$#"' -- '{}' +

FROM ghcr.io/loong64/alpine:3.21

RUN apk add --no-cache ca-certificates

ENV GOLANG_VERSION 1.24rc1

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build --link /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
