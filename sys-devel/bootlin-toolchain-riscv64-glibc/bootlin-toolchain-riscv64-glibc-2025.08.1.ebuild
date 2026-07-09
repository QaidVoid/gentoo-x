# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BOOTLIN_ARCH="riscv64-lp64d"
BOOTLIN_LIBC="glibc"
inherit bootlin-toolchain

KEYWORDS="-* ~amd64"
