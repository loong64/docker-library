#!/bin/bash
BASE_URL="https://releases.aosc.io/os-loongarch64/buildkit/"
HTML_CONTENT=$(curl -fSL "$BASE_URL")

# 提取所有 .squashfs 文件并排序
latest_file=$(echo "$HTML_CONTENT" | \
  grep -oP '(?<=<a href=")aosc-os_buildkit_\d{8}_loongarch64\.squashfs(?=")' | \
  sort -t'_' -k3nr | head -1)

echo "Latest version: $BASE_URL$latest_file"

TARBALL_URL="$BASE_URL$latest_file"

if [[ "x${TARBALL_URL}" == "x" ]]; then
  read -r -p "[*] Enter tarball download URL: " TARBALL_URL
fi
TARBALL_NAME="$(basename "${TARBALL_URL}")"
echo "[+] Downloading tarball..."
wget -q -c "${TARBALL_URL}"
if ! test -e "${TARBALL_NAME}"; then
    echo "[!] File not found?!"
    exit 127
fi

# Convert squashfs to tar.gz
TARGZ_NAME="${TARBALL_NAME%.squashfs}.tar.gz"
echo "[+] Converting squashfs to tar.gz..."
sqfs2tar "${TARBALL_NAME}" | gzip > "${TARGZ_NAME}"

# Remove the squashfs file
rm -f "${TARBALL_NAME}"
TARBALL_NAME="${TARGZ_NAME}"

TAGNAME="${TAGNAME:-aosc-os}"

IMG_VER=$(echo "${TARBALL_NAME}" | perl -nle '/^aosc-.*_(\d+)_.*$/; print $1')
if [[ "x${IMG_VER}" == 'x' && "x${UNATTENDED}" != 'x' ]]; then
  echo "[!] Unable to deduce the image version, please manually set version"
  read -r -p "[*] Enter version for this image [20180000]: " IMG_VER
else
  IMG_VER="${IMG_VER:-20190000}"
  echo "[+] Automatically set version to ${IMG_VER} ."
fi
echo -n "[+] Generating Dockerfile..."
cat << EOF > Dockerfile
FROM scratch
LABEL maintainer="loong64"
ADD "${TARBALL_NAME}" /
CMD ["/bin/bash"]
ARG CONT_IMG_VER
ENV CONT_IMG_VER=${IMG_VER}
RUN sed -i 's/*               -       nice/#*               -       nice/' /etc/security/limits.conf || true
EOF

echo " OK!"

echo "IMG_VER=${IMG_VER}" >> "$GITHUB_OUTPUT"
