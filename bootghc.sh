#! /bin/sh
set -e
git pull --rebase --recurse-submodules
git submodule update --init
rm -rf _build
./boot
./configure --enable-dwarf-unwind GHC=/home/allbery/.local/bin/ghc-9.10
