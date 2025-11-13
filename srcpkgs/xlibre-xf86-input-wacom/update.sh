#!/usr/bin/env bash

printf "Checking latest version\n"

__dir="$(dirname "${BASH_SOURCE[0]}")"

LATEST_VERSION=$(git ls-remote --tags --refs --sort="v:refname" https://github.com/X11Libre/xf86-input-wacom xlibre-xf86-input-wacom-\* | tail -n1 | sed 's/.*\///')
export VERSION=${LATEST_VERSION#"xlibre-xf86-input-wacom-"}
CURRENT_VERSION=$(grep -E '^version=' ${__dir}/template | cut -d= -f2)

printf "Latest version is: %s\nLatest built version is: %s\n" "${VERSION}" "${CURRENT_VERSION}"
[ "${CURRENT_VERSION}" = "${VERSION}" ] && printf "No new version to release\n" && exit 0

export VERSION=${VERSION%-*}

# No preprepped checksum files, need to download the binary and calculate it myself
curl --fail -sL --output xf86-input-wacom.tar.gz https://github.com/X11Libre/xf86-input-wacom/archive/refs/tags/${LATEST_VERSION}.tar.gz
export SHA256=$(sha256sum ./xf86-input-wacom.tar.gz | cut -d ' ' -f1 )
rm ./xf86-input-wacom.tar.gz
[[ ! ${SHA256} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of sha256\n" && exit 1

git clone --no-checkout --depth 1 --filter=blob:none --single-branch --branch ${LATEST_VERSION} https://github.com/X11Libre/xf86-input-wacom.git xf86-input-wacom
cd xf86-input-wacom
export GIT_SHORT_COMMIT=$(git rev-list --max-count=1 --abbrev-commit HEAD)
cd ..
rm -rf xf86-input-wacom
[[ ! ${GIT_SHORT_COMMIT} =~ ^[a-z0-9]+$ ]] && printf "got junk instead of git short commit\n" && exit 1

envsubst '${SHA256} ${VERSION} ${GIT_SHORT_COMMIT} ${TIMESTAMP}' < ${__dir}/.template > ${__dir}/template

printf "xlibre-xf86-input-wacom template updated\n"
