# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BOOTLIN_ARCH="x86-64"
BOOTLIN_LIBC="musl"
inherit bootlin-toolchain

KEYWORDS="-* ~amd64"
