#! /bin/sh

ver="${1:?please specify a cabal-install release version}"

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
