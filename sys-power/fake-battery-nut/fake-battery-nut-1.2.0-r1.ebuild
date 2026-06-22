# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 systemd

DESCRIPTION="Bridge a NUT-monitored UPS into a virtual battery for UPower"
HOMEPAGE="https://github.com/aaronsb/fake-battery-nut"
SRC_URI="https://github.com/aaronsb/fake-battery-nut/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-alternatives/bc
	sys-power/nut
"

CONFIG_CHECK="POWER_SUPPLY"

src_compile() {
	# Build via kbuild directly against the eclass-selected kernel rather
	# than the recursive upstream Makefile, which hardcodes the running
	# kernel and would break dist-kernel and cross builds.
	emake "${MODULES_MAKEARGS[@]}" -C "${KV_OUT_DIR}" M="${S}" modules
}

src_install() {
	linux_moduleinto extra
	linux_domodule fake_battery_nut.ko
	modules_post_process

	newbin nut-to-fakebattery.sh nut-to-fakebattery

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /usr/lib/modules-load.d
	newins "${FILESDIR}"/${PN}.modules-load ${PN}.conf

	einstalldocs
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	elog "Set your UPS name (upsname@host) before starting. The default is"
	elog "cyberpower@localhost."
	elog
	elog "Set NUT_UPS in /etc/conf.d/${PN}, which both init systems read."
	elog "OpenRC:  rc-service ${PN} start"
	elog "systemd: systemctl start ${PN}.service"
}
