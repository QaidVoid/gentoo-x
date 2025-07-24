# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature pax-utils xdg

DESCRIPTION="Performance oriented Firefox-based web browser"
HOMEPAGE="https://floorp.app"
SRC_URI="https://github.com/Floorp-Projects/Floorp/releases/download/v${PV}/floorp-linux-amd64.tar.xz"

S="${WORKDIR}/floorp"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="wayland"
RESTRICT="strip"

RDEPEND="
	|| (
		media-libs/libpulse
		media-sound/apulse
	)
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.26:2
	media-libs/alsa-lib
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	sys-apps/dbus
	virtual/freedesktop-icon-theme
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.11:3[X,wayland?]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	>=x11-libs/pango-1.22.0
"

src_install() {
	local instdir="/opt/${PN}"
	dodir "${instdir}"

	# Install entire binary tree to /opt
	cp -r "${S}"/* "${ED}${instdir}/" || die

	# Install launcher
	newbin "${FILESDIR}/${PN}.sh" "${PN}"

	# Desktop entry
	newmenu "${FILESDIR}/${PN}.desktop" "${PN}.desktop"

	for size in 16 32 48 64 128; do
		local icon_dir="/usr/share/icons/hicolor/${size}x${size}/apps"
		dodir "${icon_dir}"
		dosym "${instdir}/browser/chrome/icons/default/default${size}.png" \
			"${icon_dir}/floorp-bin.png"
	done

	# Install update policy
	insinto "${instdir}/distribution"
	newins "${FILESDIR}/disable-auto-update.policy.json" "policies.json"

	pax-mark m "${ED}${instdir}/floorp-bin"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature_header "Optional programs for extra features:"
	optfeature "speech syntesis (text-to-speech) support" app-accessibility/speech-dispatcher
	optfeature "fallback mouse cursor theme e.g. on WMs" gnome-base/gsettings-desktop-schemas
	optfeature "ffmpeg-based audio/video codec support, required for HTML5 video rendering" media-video/ffmpeg
	optfeature "desktop notifications" x11-libs/libnotify
}
