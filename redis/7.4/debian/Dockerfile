#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ghcr.io/loong64/debian:trixie-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN set -eux; \
	groupadd -r -g 999 redis; \
	useradd -r -g redis -u 999 redis

# runtime dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# add tzdata explicitly for https://github.com/docker-library/redis/issues/138 (see also https://bugs.debian.org/837060 and related)
		tzdata \
	; \
	rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.20
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates gnupg wget; \
	rm -rf /var/lib/apt/lists/*; \
	arch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	case "$arch" in \
		'amd64') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-amd64'; sha256='a0242b2f04c8b6e9dcc6a28a938f0daf5617bc1a0f612bd3718e6abfca97f2cd' ;; \
		'arm64') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-arm64'; sha256='ccdd4c8295a85e4a3a0ee55c7588d8b6277ff883be40e8f7f7908e0b1f108b93' ;; \
		'armel') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-armel'; sha256='f5aa6338b2640f29800efc931ee76ce832bcc9eba5c405ac1e0c221d65686696' ;; \
		'i386') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-i386'; sha256='1f337b143f6ad1162f1027a0d8ef543f0671bd918f42dc97c00e63d97de97e8f' ;; \
		'loong64') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-loong64'; sha256='6944b214714d3db48ac366d68a5a3c0c3dc86e09f7db1eca13d22be004611bba' ;; \
		'mips64el') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-mips64el'; sha256='af5222d4d2bfd51a86fe4eb1ff8997d20a63a808d202faacf8f4376c20059d3d' ;; \
		'ppc64el') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-ppc64el'; sha256='357c973b39dcb2b85e2dc674e2397da988ba8cc637297eb9236302e9ba70df7f' ;; \
		'riscv64') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-riscv64'; sha256='5bd26f46a132c9a62c2d8321a823d102c21ad50d4c94102e845cf9c4824a8ba7' ;; \
		's390x') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-s390x'; sha256='cc5c15b8c9c810aefc22c21cead21d2f485e6defee30fa8ea09e14f1f47f7389' ;; \
		'armhf') url='https://github.com/loong64/gosu/releases/download/1.20/gosu-armhf'; sha256='abf91c34b59f79744b565457f9dcd288322612c6bffe3d342d580d60901dfbf9' ;; \
		*) echo >&2 "error: unsupported gosu architecture: '$arch'"; exit 1 ;; \
	esac; \
	wget -O /usr/local/bin/gosu.asc "$url.asc"; \
	wget -O /usr/local/bin/gosu "$url"; \
	echo "$sha256 */usr/local/bin/gosu" | sha256sum -c -; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys F806E8C4741675050854E1E33617A873C05597AD; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

ENV REDIS_VERSION 7.4.12
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-7.4.12.tar.gz
ENV REDIS_DOWNLOAD_SHA 56588ee1648539556f2b6cf4e873e3734afbbe40fa952fec2fcd6b6d7dae2924

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		\
		dpkg-dev \
		gcc \
		libc6-dev \
		libssl-dev \
		make \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
	echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
	mkdir -p /usr/src/redis; \
	tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
# explicitly update autoconf config.guess and config.sub so they support more arches/libcs
	wget -O /usr/src/redis/deps/jemalloc/build-aux/config.guess 'https://github.com/cgitmirror/config/raw/refs/heads/master/config.guess'; \
	wget -O /usr/src/redis/deps/jemalloc/build-aux/config.sub 'https://github.com/cgitmirror/config/raw/refs/heads/master/config.sub'; \
	rm redis.tar.gz; \
	\
# disable Redis protected mode [1] as it is unnecessary in context of Docker
# (ports are not automatically exposed when running inside Docker, but rather explicitly by specifying -p / -P)
# [1]: https://github.com/redis/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
	grep -E '^ *createBoolConfig[(]"protected-mode",.*, *1 *,.*[)],$' /usr/src/redis/src/config.c; \
	sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' /usr/src/redis/src/config.c; \
	grep -E '^ *createBoolConfig[(]"protected-mode",.*, *0 *,.*[)],$' /usr/src/redis/src/config.c; \
# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
	\
# https://github.com/jemalloc/jemalloc/issues/467 -- we need to patch the "./configure" for the bundled jemalloc to match how Debian compiles, for compatibility
# (also, we do cross-builds, so we need to embed the appropriate "--build=xxx" values to that "./configure" invocation)
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	extraJemallocConfigureFlags="--build=$gnuArch"; \
# https://salsa.debian.org/debian/jemalloc/-/blob/c0a88c37a551be7d12e4863435365c9a6a51525f/debian/rules#L8-23
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64 | i386 | x32) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=12" ;; \
		*) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=16" ;; \
	esac; \
	extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-hugepage=21"; \
	grep -F 'cd jemalloc && ./configure ' /usr/src/redis/deps/Makefile; \
	sed -ri 's!cd jemalloc && ./configure !&'"$extraJemallocConfigureFlags"' !' /usr/src/redis/deps/Makefile; \
	grep -F "cd jemalloc && ./configure $extraJemallocConfigureFlags " /usr/src/redis/deps/Makefile; \
	\
	export BUILD_TLS=yes; \
	make -C /usr/src/redis -j "$(nproc)" all; \
	make -C /usr/src/redis install; \
	\
# TODO https://github.com/redis/redis/pull/3494 (deduplicate "redis-server" copies)
	serverMd5="$(md5sum /usr/local/bin/redis-server | cut -d' ' -f1)"; export serverMd5; \
	find /usr/local/bin/redis* -maxdepth 0 \
		-type f -not -name redis-server \
		-exec sh -eux -c ' \
			md5="$(md5sum "$1" | cut -d" " -f1)"; \
			test "$md5" = "$serverMd5"; \
		' -- '{}' ';' \
		-exec ln -svfT 'redis-server' '{}' ';' \
	; \
	\
	rm -r /usr/src/redis; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
	redis-cli --version; \
	redis-server --version

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
