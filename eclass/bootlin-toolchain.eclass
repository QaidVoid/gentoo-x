# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bootlin-toolchain.eclass
# @MAINTAINER:
# Rabindra Dhakal <contact@qaidvoid.dev>
# @AUTHOR:
# Rabindra Dhakal <contact@qaidvoid.dev>
# @SUPPORTED_EAPIS: 8
# @BLURB: Install prebuilt cross-toolchains from toolchains.bootlin.com
# @DESCRIPTION:
# Bootlin publishes prebuilt buildroot-based cross-toolchains. This
# eclass fetches a toolchain tarball and installs it under
# /opt/bootlin/<arch>-<libc>, performing the same path relocation that
# the bundled relocate-sdk.sh script would do, but against the final
# install location.
#
# The ebuild must set BOOTLIN_ARCH and BOOTLIN_LIBC before inheriting.
# The package version maps 1:1 to the bootlin release, with the last
# separator flipped: 2025.08.1 fetches release 2025.08-1.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_BOOTLIN_TOOLCHAIN_ECLASS} ]]; then
_BOOTLIN_TOOLCHAIN_ECLASS=1

# @ECLASS_VARIABLE: BOOTLIN_ARCH
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Bootlin architecture name, e.g. x86-64, aarch64, riscv64-lp64d.

# @ECLASS_VARIABLE: BOOTLIN_LIBC
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Target C library: glibc, musl or uclibc.

# @ECLASS_VARIABLE: BOOTLIN_VARIANT
# @PRE_INHERIT
# @DESCRIPTION:
# Toolchain variant: stable (default) or bleeding-edge.
: "${BOOTLIN_VARIANT:=stable}"

[[ -z ${BOOTLIN_ARCH} ]] && die "${ECLASS}: BOOTLIN_ARCH must be set"
[[ -z ${BOOTLIN_LIBC} ]] && die "${ECLASS}: BOOTLIN_LIBC must be set"

_BOOTLIN_P="${BOOTLIN_ARCH}--${BOOTLIN_LIBC}--${BOOTLIN_VARIANT}-$(ver_rs 2 - "${PV}")"

# @ECLASS_VARIABLE: BOOTLIN_DEST
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Installation prefix of the toolchain, relative to EPREFIX.
BOOTLIN_DEST="/opt/bootlin/${BOOTLIN_ARCH}-${BOOTLIN_LIBC}"

DESCRIPTION="Prebuilt Bootlin ${BOOTLIN_ARCH} ${BOOTLIN_LIBC} cross-toolchain (${BOOTLIN_VARIANT})"
HOMEPAGE="https://toolchains.bootlin.com/"
SRC_URI="https://toolchains.bootlin.com/downloads/releases/toolchains/${BOOTLIN_ARCH}/tarballs/${_BOOTLIN_P}.tar.xz"
S="${WORKDIR}/${_BOOTLIN_P}"

# gcc, binutils, gdb and the bundled target runtime libraries.
LICENSE="GPL-3+ LGPL-3+ GPL-2+ LGPL-2.1+ BSD MIT"
SLOT="0"

# Prebuilt host binaries for x86_64/glibc; stripping or re-linking
# them (and the target sysroot libraries) must be left alone.
RESTRICT="strip"

# @ECLASS_VARIABLE: QA_PREBUILT
# @INTERNAL
# @DESCRIPTION:
# The whole toolchain tree is prebuilt.
QA_PREBUILT="opt/bootlin/*"

BDEPEND="sys-apps/file"

EXPORT_FUNCTIONS src_install pkg_postinst

# @FUNCTION: bootlin-toolchain_src_install
# @DESCRIPTION:
# Relocate the SDK to its final path and install it under BOOTLIN_DEST,
# plus an env.d entry adding its bin/ directory to PATH.
bootlin-toolchain_src_install() {
	local dest="${EPREFIX}${BOOTLIN_DEST}"

	# Upstream script rewrites the recorded build path in all text
	# files; with an argument it targets that path instead of PWD.
	sh "${S}"/relocate-sdk.sh "${dest}" || die "SDK relocation failed"
	rm -f "${S}"/relocate-sdk.sh || die

	dodir "${BOOTLIN_DEST%/*}"
	mv "${S}" "${ED}${BOOTLIN_DEST}" || die

	newenvd - "60${PN}" <<-EOF
		PATH="${dest}/bin"
	EOF
}

# @FUNCTION: bootlin-toolchain_pkg_postinst
# @DESCRIPTION:
# Point the user at the installed tools.
bootlin-toolchain_pkg_postinst() {
	elog "Toolchain installed in ${EPREFIX}${BOOTLIN_DEST}"
	elog "Run 'env-update && source /etc/profile' to get its bin/ in PATH."
	elog "Note: the host binaries require a glibc host to run."
}

fi
