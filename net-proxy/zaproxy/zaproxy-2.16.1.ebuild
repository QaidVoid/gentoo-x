# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="The OWASP Zed Attack Proxy for finding vulnerabilities in web applications"
HOMEPAGE="https://github.com/zaproxy/zaproxy"

SRC_URI="https://github.com/zaproxy/zaproxy/releases/download/v${PV}/ZAP_${PV}_Linux.tar.gz"

S="${WORKDIR}/ZAP_${PV}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-11:*"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default
}

src_install() {
	insinto "/opt/${PN}"
	doins -r "${S}"/*

	fperms +x "/opt/${PN}/zap.sh"

	dosym -r "/opt/${PN}/zap.sh" "/usr/bin/zaproxy"

	doicon "${FILESDIR}/${PN}.png"

	domenu "${FILESDIR}/${PN}.desktop"
}
