# Copyright 2001-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager"
HOMEPAGE="https://pnpm.io"
SRC_URI="https://registry.npmjs.org/pnpm/-/pnpm-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="net-libs/nodejs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/package"

src_prepare() {
	default

	rm -rf dist/node-gyp-bin dist/node_modules/node-gyp dist/vendor

	find . -type f \( \
		-name '.*' -o \
		-name '*.map' -o \
		-name '*.darwin*' -o \
		-name '*.win*' \) -delete
}

src_install() {
	local install_dir="/usr/share/node_modules/pnpm"
	insinto "${install_dir}"
	doins -r .
	dosym "../share/node_modules/pnpm/bin/pnpm.cjs" "/usr/bin/pnpm"
	dosym "../share/node_modules/pnpm/bin/pnpx.cjs" "/usr/bin/pnpx"

	fperms +x /usr/bin/pnpm
	fperms +x /usr/bin/pnpx
}
