#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM ghcr.io/loong64/alpine:3.21

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN set -eux; \
# alpine already has a gid 999, so we'll use the next id
	addgroup -S -g 1000 redis; \
	adduser -S -G redis -u 999 redis

# runtime dependencies
RUN set -eux; \
	apk add --no-cache \
# add tzdata for https://github.com/docker-library/redis/issues/138
		tzdata \
	;

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.19
RUN set -eux; \
	apk add --no-cache --virtual .gosu-fetch gnupg; \
	arch="$(apk --print-arch)"; \
	case "$arch" in \
		'x86_64') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-amd64'; sha256='a6b1a92b07f95f850c79e701ff11d0e11868ac1063ef62cd0da23cc84b756fee' ;; \
		'aarch64') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-arm64'; sha256='3fdfeec388e2a297c42d0694f122aaf90d92469bfa44bb7b429de6aafca518cb' ;; \
		'armhf') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-armhf'; sha256='f186ca630c28cbaaa1ed304767278126761a109164aa8576ddad6b2ce2a5184b' ;; \
		'x86') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-i386'; sha256='c02a039911b9d0a0766eac73d738b43d062fe5217ab0c0acb661f4f9d3ce0258' ;; \
		'loongarch64') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-loong64'; sha256='1832189ef2dc568eff990450c13478092a1fa9cf75815bd17c80b4b48ccf217f' ;; \
		'ppc64le') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-ppc64el'; sha256='30abaa78270d6ccb5f83940105cbcafdd378f4b5f7ebc49cf8f774f5d7159088' ;; \
		'riscv64') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-riscv64'; sha256='5d2a74d3da0e12f4e07c45318f27e3c6be9dd8fddf871226642ba9e38a00f362' ;; \
		's390x') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-s390x'; sha256='0b9d65e50364511708d7df873a0b32a896996346844603d3e2cd68cbe892c0d3' ;; \
		'armv7') url='https://github.com/loong64/gosu/releases/download/1.19/gosu-armhf'; sha256='f186ca630c28cbaaa1ed304767278126761a109164aa8576ddad6b2ce2a5184b' ;; \
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
	apk del --no-network .gosu-fetch; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

ENV REDIS_VERSION 7.2.12
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-7.2.12.tar.gz
ENV REDIS_DOWNLOAD_SHA 97c60478a7c777ac914ca9d87a7e88ba265926456107e758c62d8f971d0196bc

RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		dpkg-dev dpkg \
		gcc \
		linux-headers \
		make \
		musl-dev \
		openssl-dev \
# install real "wget" to avoid:
#   + wget -O redis.tar.gz https://download.redis.io/releases/redis-x.y.z.tar.gz
#   Connecting to download.redis.io (45.60.121.1:80)
#   wget: bad header line:     XxhODalH: btu; path=/; Max-Age=900
		wget \
	; \
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
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .redis-rundeps $runDeps; \
	apk del --no-network .build-deps; \
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
