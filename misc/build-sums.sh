#!/bin/sh

echo 'Generating hash sums of source and build trees ...' >&2

cat << END
# Chromium source and build tree MD5 hash sums
# (sorted by last-modified timestamp, oldest to newest)
# Chromium upstream version: ${CHROMIUM_VERSION:-unknown}
#
END

find . -type f \
	\! -name .ninja_\* \
	\! -name __jinja2_\*.cache \
	\! -name ghci-\* \
	\! -name gn_logs.txt \
	\! -name \*.d \
	\! -name \*.ninja \
	\! -path ./out/\*/thinlto-cache/llvmcache-\* \
	-printf '%T@\t%P\n' \
| LC_COLLATE=C sort -k 1,1g -k 2b \
| cut -f2- \
| xargs -d '\n' md5sum
