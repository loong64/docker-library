# Copied from https://github.com/docker-library/php with some changes for loongarch64:
```
diff --git a/Dockerfile-linux.template b/Dockerfile-linux.template
index 4d423b8..1d0f4ee 100644
--- a/Dockerfile-linux.template
+++ b/Dockerfile-linux.template
@@ -11,7 +11,7 @@
 		)
 	;
 	def is_alpine:
-		env.from | startswith("alpine")
+		env.from | startswith("ghcr.io/loong64/alpine")
 -}}
 FROM {{ env.from }}
 
@@ -265,6 +265,7 @@ RUN set -eux; \
 			if env.version | rtrimstr("-rc") == "8.1" then "patch", "patchutils" else empty end,
 			"readline-dev",
 			"sqlite-dev",
+			"libucontext-dev",
 			# https://github.com/docker-library/php/issues/888
 			"linux-headers",
 			# oniguruma is part of mbstring in php 7.4+
@@ -299,7 +300,7 @@ RUN set -eux; \
 	export \
 		CFLAGS="$PHP_CFLAGS" \
 		CPPFLAGS="$PHP_CPPFLAGS" \
-		LDFLAGS="$PHP_LDFLAGS" \
+		LDFLAGS="$PHP_LDFLAGS -lucontext" \
 # https://github.com/php/php-src/blob/d6299206dd828382753453befd1b915491b741c6/configure.ac#L1496-L1511
 		PHP_BUILD_PROVIDER='https://github.com/docker-library/php' \
 		PHP_UNAME='Linux - Docker' \
@@ -385,6 +386,7 @@ RUN set -eux; \
 		$(test "$gnuArch" = 'riscv64-linux-gnu' && echo '--without-pcre-jit') \
 {{ ) end -}}
 {{ ) else "" end -}}
+		--without-pcre-jit \
 {{ if is_alpine then "" else ( -}}
 		--with-libdir="lib/$debMultiarch" \
 {{ ) end -}}
diff --git a/apply-templates.sh b/apply-templates.sh
index a644fe5..068be8e 100755
--- a/apply-templates.sh
+++ b/apply-templates.sh
@@ -47,7 +47,7 @@ for version; do
 
 		alpineVer="${suite#alpine}" # "3.12", etc
 		if [ "$suite" != "$alpineVer" ]; then
-			from="alpine:$alpineVer"
+			from="ghcr.io/loong64/alpine:$alpineVer"
 		else
 			from="debian:$suite-slim"
 		fi
diff --git a/versions.sh b/versions.sh
index 6788066..5dbdddb 100755
--- a/versions.sh
+++ b/versions.sh
@@ -85,10 +85,7 @@ for version in "${versions[@]}"; do
 	variants='[]'
 	# order here controls the order of the library/ file
 	for suite in \
-		bookworm \
-		bullseye \
 		alpine3.21 \
-		alpine3.20 \
 	; do
 		for variant in cli apache fpm zts; do
 			if [[ "$suite" = alpine* ]]; then
```

# License Notice
All mirrored code remains copyrighted by its original authors. This organization only provides synchronization serivices.

Always verify licensing terms in the upstream repository's LICENSE file before use.
