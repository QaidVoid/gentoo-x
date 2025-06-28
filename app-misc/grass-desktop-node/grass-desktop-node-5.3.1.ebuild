# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Lightweight standalone app that rewards users for sharing bandwidth"
HOMEPAGE="https://app.getgrass.io/dashboard/store/item/desktop"
SRC_URI="https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_${PV}_amd64.deb"

S="${WOKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	net-libs/webkit-gtk:4.1
"

QA_PREBUILT="/usr/bin/grass"

src_unpack() {
	unpack_deb "${DISTDIR}/Grass_${PV}_amd64.deb"
}

src_install() {
	cp -a "${S}/usr" "${D}/"

	if [[ -f "${D}/usr/share/applications/Grass.desktop" ]]; then
		chmod 644 "${D}/usr/share/applications/Grass.desktop"
	fi
}
