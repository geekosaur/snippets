#! /bin/sh

ver="${1:?please specify a cabal-install release version}"

if test -f "cabal-install-$ver.tar.gz"; then
	:
else
	echo please run me from a directory containing local copies of release files
	exit 1
fi

cxP() {
	curl -x PURGE "$@"
}

r="http://downloads.haskell.org/~cabal/cabal-install-"

for v in "$ver" latest; do
	cxP "$r$v"
	for f in '' *; do
		cxP "$r$v/$f"
	done
done
