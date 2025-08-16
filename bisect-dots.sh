#! /bin/sh
# if the test doesn't exist, it can't fail
test -f cabal-testsuite/PackageTests/Regression/T9640/cabal.test.hs || exit 0

skip() {
	git reset --hard
	echo "$@"
	exit 125
}

if patch -p1 -f -N -r - -s < ../cabal-ghc-9.10-diff; then
	:
else
	git reset --hard
	if patch -p1 -f -N -r - -s < ../cabal-ghc-9.10-diff-old; then 
		:
	else
		skip "patch failed"
	fi
fi

# caabal version forced here due to https://github.com/haskell/cabal/pull/10251
# see https://github.com/haskell/cabal/blob/master/cabal-testsuite/cabal-testsuite.cabal#L152-L158
# adjust as needed for the cabal version being tested
cabal-3.10.3.0 clean || skip "clean failed"
cabal-3.10.3.0 build -w ghc-9.10.1 cabal || skip "build failed"
cabal-3.10.3.0 build -w ghc-9.10.1 cabal-testsuite:cabal-tests || skip "testsuite build failed"

cabal-3.10.3.0 run -w ghc-9.10.1 cabal-testsuite:cabal-tests -- --with-ghc=ghc-9.10.1 --with-cabal=$(cabal-3.10.3.0 list-bin -w ghc-9.10.1 cabal) cabal-testsuite/PackageTests/Regression/T9640/cabal.test.hs
rc=$?

git reset --hard

exit $rc
