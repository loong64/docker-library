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
ENV GOSU_VERSION 1.17
RUN set -eux; \
	apk add --no-cache --virtual .gosu-fetch gnupg; \
	arch="$(apk --print-arch)"; \
	case "$arch" in \
		'x86_64') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-amd64'; sha256='4a2a8fcbc77d41f14fc2037ac96545e3a24dcf8ec9c7b0010f5612111838a170' ;; \
		'aarch64') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-arm64'; sha256='c05db37571617568478d9f71baf1b5c7623cb006db3096307e6cdd7c1dffcee7' ;; \
		'armhf') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-armhf'; sha256='91435d8e984592d8ff0382f1ff5ca8ff753320dd549b4253568f696b8b540643' ;; \
		'x86') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-i386'; sha256='32e01bb5910fe3ead279c29d413c6889dd6083ba6738d9a231353cbb8526a78c' ;; \
		'loongarch64') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-loong64'; sha256='4aba41555306a44336c52b6f46557910ee806e7682429d6593c906a260154109' ;; \
		'ppc64le') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-ppc64el'; sha256='d68337e36705f6d1796b0b6fac0458e9e504ba53a13f5b82678ed36273207dd5' ;; \
		'riscv64') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-riscv64'; sha256='4adfb89846f4e50a0a3eb5a91f32d98305d5e6e4b206e02d733377a8b15e1d38' ;; \
		's390x') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-s390x'; sha256='bc8cb9738e3d1e54d9949498718022a4238e9733c2385b0b65c87b38e113be47' ;; \
		'armv7') url='https://github.com/loong64/gosu/releases/download/1.17/gosu-armhf'; sha256='91435d8e984592d8ff0382f1ff5ca8ff753320dd549b4253568f696b8b540643' ;; \
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

ENV REDIS_VERSION 7.0.15
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-7.0.15.tar.gz
ENV REDIS_DOWNLOAD_SHA 98066f5363504b26c34dd20fbcc3c957990d764cdf42576c836fc021073f4341

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
