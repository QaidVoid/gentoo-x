# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="Find files with SQL-like queries"
HOMEPAGE="https://github.com/jhspetersson/fselect"
SRC_URI="
	https://github.com/jhspetersson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/QaidVoid/cargo-vendored/releases/download/v${PV}-${PN}/${P}-vendored-dependencies.tar.xz
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 GPL-2+ ISC MIT MPL-2.0 Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+users"

ECARGO_VENDOR="${WORKDIR}/vendor"

QA_FLAGS_IGNORED="/usr/bin/fselect"
DOCS=( README.md docs/usage.md )

src_configure() {
	local myfeatures=(
		$(usev users)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install
	doman docs/*.1
	einstalldocs
}
