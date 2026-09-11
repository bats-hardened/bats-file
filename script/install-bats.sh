#!/bin/sh
set -o errexit
set -o xtrace

git clone --depth 1 https://github.com/bats-hardened/bats-core
cd bats-core && ./install.sh "${HOME}/.local" && cd .. && rm -rf bats-core
