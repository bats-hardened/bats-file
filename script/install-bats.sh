#!/bin/sh
set -eu

bats_npm_package='bats'
bats_version=$(
  npm query "#${bats_npm_package}" --package-lock-only |
    node -p 'JSON.parse(require("fs").readFileSync(0, "utf8"))[0].version'
)
bats_archive_url="https://github.com/bats-core/bats-core/archive/refs/tags/v${bats_version}.tar.gz"
bats_tmp_dir=$(mktemp -d)

set -- \
  --fail \
  --location \
  --silent \
  --show-error \
  --retry 4 \
  --retry-connrefused
if [ -n "${GITHUB_TOKEN:-}" ]; then
  set -- "$@" --header "Authorization: Bearer $GITHUB_TOKEN"
fi

curl "$@" \
  --output "${bats_tmp_dir}/bats-core.tar.gz" \
  "$bats_archive_url"
tar -xzf "${bats_tmp_dir}/bats-core.tar.gz" -C "$bats_tmp_dir"
"${bats_tmp_dir}/bats-core-${bats_version}/install.sh" "${HOME}/.local"
rm -rf "$bats_tmp_dir"
