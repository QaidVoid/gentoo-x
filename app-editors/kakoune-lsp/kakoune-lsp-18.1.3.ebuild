# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="Kakoune Language Server Protocol Client"
HOMEPAGE="https://github.com/kakoune-lsp/kakoune-lsp"
SRC_URI="
	https://github.com/kakoune-lsp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/QaidVoid/cargo-vendored/releases/download/v${PV}-${PN}/${P}-vendored-dependencies.tar.xz
"

LICENSE="|| ( MIT Unlicense )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

ECARGO_VENDOR="${WORKDIR}/vendor"

QA_FLAGS_IGNORED="usr/bin/kak-lsp"

src_install() {
	cargo_src_install
}
