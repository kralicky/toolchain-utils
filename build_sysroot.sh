#!/bin/bash

set -eu -o pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"; readonly SCRIPT_DIR

temp="$(/bin/mktemp -d -p .)"

pushd "${temp}"

docker buildx build -f "${SCRIPT_DIR}/sysroot.dockerfile" \
  --platform linux/amd64,linux/arm64 \
  --output=type=local,dest=out \
  .

/bin/tar -cf "sysroot-linux-amd64.tar" -C out/ linux_amd64
/bin/zstd -T0 --long -10 --rm "sysroot-linux-amd64.tar"
/bin/mv "sysroot-linux-amd64.tar.zst" ..

/bin/tar -cf "sysroot-linux-arm64.tar" -C out/ linux_arm64
/bin/zstd -T0 --long -10 --rm "sysroot-linux-arm64.tar"
/bin/mv "sysroot-linux-arm64.tar.zst" ..

popd
rm -rf "${temp}"
