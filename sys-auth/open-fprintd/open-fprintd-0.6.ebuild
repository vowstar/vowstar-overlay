# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1 systemd

DESCRIPTION="D-Bus clients to access fingerprint readers"
HOMEPAGE="https://github.com/uunicorn/open-fprintd"
SRC_URI="https://github.com/uunicorn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"

RDEPEND="
	!sys-auth/fprintd
	sys-auth/fprintd-clients
"
DEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	systemd_dounit "${S}"/debian/open-fprintd.service
	systemd_dounit "${S}"/debian/open-fprintd-resume.service
	systemd_dounit "${S}"/debian/open-fprintd-suspend.service
}

pkg_postinst() {
	elog "To make sure fingerprint working after waking up from suspend:"
	elog "systemctl enable open-fprintd-resume open-fprintd-suspend"
}