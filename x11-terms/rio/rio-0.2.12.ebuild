# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.81"

inherit cargo desktop

DESCRIPTION="Rio terminal is a hardware-accelerated GPU terminal emulator, focusing to run in desktops and browsers."
HOMEPAGE="https://raphamorim.io/rio"
SRC_URI="
	https://github.com/raphamorim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/QaidVoid/cargo-vendored/releases/download/v${PV}-${PN}/${P}-vendored-dependencies.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="amd64"
IUSE="+wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	media-libs/freetype:2
	media-libs/fontconfig
	wayland? ( dev-libs/wayland )
	wayland? ( x11-libs/libxkbcommon[wayland] )
	X? ( x11-libs/libxkbcommon[X] )
	sys-libs/ncurses
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

ECARGO_VENDOR="${WORKDIR}/vendor"

QA_FLAGS_IGNORED="/usr/bin/rio"
DOCS=( README.md docs/docs )

src_prepare() {
	default
	sed -i '/^strip =/d' Cargo.toml || die
}

src_configure() {
    local myfeatures=(
        $(usev wayland)
        $(usev X x11)
    )
    cargo_src_configure --no-default-features
}

src_install() {
	dobin "$(cargo_target_dir)/${PN}"

	dodoc -r "${DOCS[@]}"
    newicon -s scalable "misc/logo.svg" "${PN}.svg"
    domenu "misc/${PN}.desktop"
}
