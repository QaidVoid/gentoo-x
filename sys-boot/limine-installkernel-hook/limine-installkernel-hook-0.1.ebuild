# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Auto-manage kernel boot entries in limine.conf via installkernel hooks"
HOMEPAGE="https://github.com/qaidvoid/limine-installkernel-hook"
SRC_URI="https://github.com/qaidvoid/limine-installkernel-hook/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-kernel/installkernel"

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		SYSCONFDIR="${EPREFIX}/etc" \
		install install-gentoo
}

pkg_postinst() {
	# Traditional installkernel has no removal phase, so source the shipped
	# Portage postrm bridge from the user's bashrc. Idempotent.
	local bashrc="${EROOT}/etc/portage/bashrc"
	if ! grep -q '>>> limine-installkernel-hook >>>' "${bashrc}" 2>/dev/null; then
		{
			echo "# >>> limine-installkernel-hook >>>"
			echo "source /usr/libexec/limine-update/portage-hook.sh"
			echo "# <<< limine-installkernel-hook <<<"
		} >> "${bashrc}" || ewarn "Failed to enable postrm hook in ${bashrc}"
		elog "Enabled kernel-removal hook in ${bashrc}."
	fi

	elog
	elog "Configure markers and (optionally) the command line in"
	elog "  ${EROOT}/etc/limine-update.conf"
	elog "The command line otherwise comes from ${EROOT}/etc/kernel/cmdline."
	elog
	elog "Mark the auto-managed region in"
	elog "  ${EROOT}/boot/EFI/limine/limine.conf"
	elog "with these lines around your Gentoo entries:"
	elog "    # >>> gentoo kernels >>>"
	elog "    # <<< gentoo kernels <<<"
	elog "then run: limine-update"

	# Seed the conf now if the markers are already in place.
	local conf="${EROOT}/boot/EFI/limine/limine.conf"
	if [ -f "${conf}" ] && grep -q '# >>> gentoo kernels >>>' "${conf}"; then
		"${EROOT}/usr/sbin/limine-update" || ewarn "Initial limine-update run failed"
	fi
}

pkg_prerm() {
	# Remove the bashrc source block this package added.
	local bashrc="${EROOT}/etc/portage/bashrc"
	if [ -f "${bashrc}" ]; then
		sed -i '/>>> limine-installkernel-hook >>>/,/<<< limine-installkernel-hook <<</d' \
			"${bashrc}" || ewarn "Failed to clean postrm hook from ${bashrc}"
	fi
}
