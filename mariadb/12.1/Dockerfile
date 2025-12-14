# vim:set ft=dockerfile:
FROM ghcr.io/loong64/debian:trixie-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql --home-dir /var/lib/mysql

# add gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
# gosu key is B42F6819007F00F88E364FD4036A9C25BF357DD4
ENV GOSU_VERSION 1.19

ARG GPG_KEYS=177F4010FE56CA3336300305F1656F24C74CD1D8
# pub   rsa4096 2016-03-30 [SC]
#         177F 4010 FE56 CA33 3630  0305 F165 6F24 C74C D1D8
# uid           [ unknown] MariaDB Signing Key <signing-key@mariadb.org>
# sub   rsa4096 2016-03-30 [E]
# install "libjemalloc2" as it offers better performance in some cases. Use with LD_PRELOAD
# install "libtcmalloc-minimal4t64" as it may improve performance and fix memory fragmentation issues. Use with LD_PRELOAD
# install "pwgen" for randomizing passwords
# install "tzdata" for /usr/share/zoneinfo/
# install "xz-utils" for .sql.xz docker-entrypoint-initdb.d files
# install "zstd" for .sql.zst docker-entrypoint-initdb.d files
# hadolint ignore=SC2086
RUN set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		ca-certificates \
		gpg \
		gpgv \
		libjemalloc2 \
		libtcmalloc-minimal4t64 \
		pwgen \
		tzdata \
		xz-utils \
		zstd ; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get install -y --no-install-recommends \
		dirmngr \
		gpg-agent \
		wget; \
	rm -rf /var/lib/apt/lists/*; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -q -O /usr/local/bin/gosu "https://github.com/loong64/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -q -O /usr/local/bin/gosu.asc "https://github.com/loong64/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	GNUPGHOME="$(mktemp -d)"; \
	export GNUPGHOME; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys F806E8C4741675050854E1E33617A873C05597AD; \
	for key in $GPG_KEYS; do \
		gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	done; \
	gpg --batch --export "$GPG_KEYS" > /etc/apt/trusted.gpg.d/mariadb.gpg; \
	if command -v gpgconf >/dev/null; then \
		gpgconf --kill all; \
	fi; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] ||	apt-mark manual $savedAptMark >/dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

# Ensure the container exec commands handle range of utf8 characters based of
# default locales in base image (https://github.com/docker-library/docs/blob/135b79cc8093ab02e55debb61fdb079ab2dbce87/ubuntu/README.md#locales)
ENV LANG C.UTF-8

# bashbrew-architectures: amd64 arm64v8 ppc64le s390x
ARG MARIADB_VERSION=1:12.1.2+maria~deb13
ENV MARIADB_VERSION $MARIADB_VERSION
# release-status:Stable
# release-support-type:Rolling
# (https://downloads.mariadb.org/rest-api/mariadb/)

RUN set -ex; \
	{ \
		echo "mariadb-server" mysql-server/root_password password 'unused'; \
		echo "mariadb-server" mysql-server/root_password_again password 'unused'; \
	} | debconf-set-selections; \
	\
# see note below about "*.pyc" files
	export PYTHONDONTWRITEBYTECODE=1; \
	\
	dpkgArch="$(dpkg --print-architecture)"; \
	aptRepo="[ signed-by=/etc/apt/trusted.gpg.d/mariadb.gpg ] http://archive.mariadb.org/mariadb-12.1.2/repo/debian/ trixie main"; \
	case "$dpkgArch" in \
		amd64 | arm64 | ppc64el | s390x) \
# arches officialy built by upstream
			echo "deb $aptRepo" > /etc/apt/sources.list.d/pgdg.list; \
			apt-get update; \
			;; \
		*) \
# we're on an architecture upstream doesn't officially build for
# let's build binaries from their published source packages
			echo "deb-src $aptRepo" > /etc/apt/sources.list.d/pgdg.list; \
			\
			savedAptMark="$(apt-mark showmanual)"; \
			\
			tempDir="$(mktemp -d)"; \
			cd "$tempDir"; \
			\
# create a temporary local APT repo to install from (so that dependency resolution can be handled by APT, as it should be)
			apt-get update; \
			apt-get install -y --no-install-recommends dpkg-dev; \
			echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list; \
			_update_repo() { \
				dpkg-scanpackages . > Packages; \
# work around the following APT issue by using "Acquire::GzipIndexes=false" (overriding "/etc/apt/apt.conf.d/docker-gzip-indexes")
#   Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
#   ...
#   E: Failed to fetch store:/var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages  Could not open file /var/lib/apt/lists/partial/_tmp_tmp.ODWljpQfkE_._Packages - open (13: Permission denied)
				apt-get -o Acquire::GzipIndexes=false update; \
			}; \
			_update_repo; \
			\
# build .deb files from upstream's source packages (which are verified by apt-get)
			nproc="$(nproc)"; \
			export DEB_BUILD_OPTIONS="nocheck parallel=$nproc"; \
			apt-get build-dep -y "mariadb-server=$MARIADB_VERSION"; \
			apt-get source --compile "mariadb-server=$MARIADB_VERSION"; \
			\
# we don't remove APT lists here because they get re-downloaded and removed later
			\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
# (which is done after we install the built packages so we don't have to redownload any overlapping dependencies)
			apt-mark showmanual | xargs apt-mark auto > /dev/null; \
			apt-mark manual $savedAptMark; \
			\
			ls -lAFh; \
			_update_repo; \
			grep '^Package: ' Packages; \
			cd /; \
			{ \
				echo 'Package: *'; \
				echo 'Pin: origin ""'; \
				echo 'Pin-Priority: 1001'; \
			} > /etc/apt/preferences.d/mariadb; \
			;; \
	esac; \
# postinst script creates a datadir, so avoid creating it by faking its existance.
	mkdir -p /var/lib/mysql/mysql ; touch /var/lib/mysql/mysql/user.frm ; \
# mariadb-backup is installed at the same time so that `mysql-common` is only installed once from just mariadb repos
	apt-get install -y --no-install-recommends mariadb-server="$MARIADB_VERSION" mariadb-backup socat \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	if [ -n "$tempDir" ]; then \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
		apt-get purge -y --auto-remove; \
		rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
		rm -rf /etc/apt/preferences.d/mariadb; \
	fi; \
	\
# some of the steps above generate a lot of "*.pyc" files (and setting "PYTHONDONTWRITEBYTECODE" beforehand doesn't propagate properly for some reason), so we clean them up manually (as long as they aren't owned by a package)
	find /usr -name '*.pyc' -type f -exec bash -c 'for pyc; do dpkg -S "$pyc" &> /dev/null || rm -vf "$pyc"; done' -- '{}' +; \
	\
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql /run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /run/mysqld; \
# ensure that /run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 1777 /run/mysqld; \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/'; \
# don't reverse lookup hostnames, they are usually another container
	printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" > /etc/mysql/mariadb.conf.d/05-skipcache.cnf; \
# Issue #327 Correct order of reading directories /etc/mysql/mariadb.conf.d before /etc/mysql/conf.d (mount-point per documentation)
	if [ -L /etc/mysql/my.cnf ]; then \
# 10.5+
		sed -i -e '/includedir/ {N;s/\(.*\)\n\(.*\)/\n\2\n\1/}' /etc/mysql/mariadb.cnf; \
	fi


VOLUME /var/lib/mysql

COPY healthcheck.sh /usr/local/bin/healthcheck.sh
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mariadbd"]