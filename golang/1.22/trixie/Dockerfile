#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ghcr.io/loong64/buildpack-deps:trixie-scm AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.22.6

RUN set -eux; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	case "$arch" in \
		'amd64') \
			url='https://dl.google.com/go/go1.22.6.linux-amd64.tar.gz'; \
			sha256='999805bed7d9039ec3da1a53bfbcafc13e367da52aa823cb60b68ba22d44c616'; \
			;; \
		'armhf') \
			url='https://dl.google.com/go/go1.22.6.linux-armv6l.tar.gz'; \
			sha256='b566484fe89a54c525dd1a4cbfec903c1f6e8f0b7b3dbaf94c79bc9145391083'; \
			;; \
		'arm64') \
			url='https://dl.google.com/go/go1.22.6.linux-arm64.tar.gz'; \
			sha256='c15fa895341b8eaf7f219fada25c36a610eb042985dc1a912410c1c90098eaf2'; \
			;; \
		'i386') \
			url='https://dl.google.com/go/go1.22.6.linux-386.tar.gz'; \
			sha256='9e680027b058beab10ce5938607660964b6d2c564bf50bdb01aa090dc5beda98'; \
			;; \
		'loong64') \
			url='https://dl.google.com/go/go1.22.6.linux-loong64.tar.gz'; \
			sha256='1ee6e1896aea856142d2af7045cea118995b39404aa61afd12677d023d47ee69'; \
			;; \
		'mips64el') \
			url='https://dl.google.com/go/go1.22.6.linux-mips64le.tar.gz'; \
			sha256='01547606c5b5c1b0e5587b3afd65172860d2f4755e523785832905759ecce2d7'; \
			;; \
		'ppc64el') \
			url='https://dl.google.com/go/go1.22.6.linux-ppc64le.tar.gz'; \
			sha256='9d99fce3f6f72a76630fe91ec0884dfe3db828def4713368424900fa98bb2bd6'; \
			;; \
		'riscv64') \
			url='https://dl.google.com/go/go1.22.6.linux-riscv64.tar.gz'; \
			sha256='30be9c9b9cc4f044d4da9a33ee601ab7b3aff4246107d323a79e08888710754e'; \
			;; \
		's390x') \
			url='https://dl.google.com/go/go1.22.6.linux-s390x.tar.gz'; \
			sha256='82f3bae3ddb4ede45b848db48c5486fadb58551e74507bda45484257e7194a95'; \
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

ENV GOLANG_VERSION 1.22.6

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=build --link /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
