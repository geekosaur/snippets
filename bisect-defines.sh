#! /bin/sh

# This is how I bisected https://github.com/haskell/cabal/pull/9914#issuecomment-2070520170
# Bisecting ghc needs some handholding

here="$(pwd)"

git submodule update --init --force || exit 125

rm -rf _build || exit 125
./boot || exit 125
./configure || exit 125
hadrian/build -j12 || exit 125

ghc="$(pwd)/_build/stage1/bin/ghc"

cd $HOME/Sources/cabal || exit 125
# strictly, this should be done; but cabal depends on some packages that don't build
# with many ghc/base prereleases (notably base-orphans and th-compat)
#rm -rf dist-newstyle || exit 125
#cabal-3.10.3.0 build all -j12 -w "$ghc" --project-file=cabal.project.validate || exit 125

#cabal="$(cabal-3.10.3.0 list-bin cabal -w "$ghc")"
cabal=cabal-head

# this is the test that was failing
"$cabal" run -j12 cabal-testsuite:cabal-tests -- --with-cabal="$cabal" --with-ghc="$ghc" --intree-cabal-lib="$HOME/Sources/cabal" --test-tmp="$(pwd)/testdb" cabal-testsuite/PackageTests/CCompilerOverride/setup.test.hs
rc=$?

rm -rf testdb || :

cd "$here" || exit 125
# ???
rm -f libraries/ghc-prim/ghc-prim.cabal || :
# probably overkill
git reset --hard || :
git clean -fdx || :
git submodule foreach git clean -fdx || :
exit $rc
