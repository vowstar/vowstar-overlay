# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy )

inherit distutils-r1 systemd

DESCRIPTION="Validity fingerprint sensor prototype"
HOMEPAGE="https://github.com/uunicorn/python-validity"
SRC_URI="https://github.com/uunicorn/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

IUSE="systemd"

KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/innoextract
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-auth/fprintd-clients
	sys-auth/open-fprintd
"

DEPEND="
	${RDEPEND}
"

python_install_all() {
	distutils-r1_python_install_all
	systemd_dounit "${S}"/debian/python3-validity.service
	udev_newrules "${S}"/debian/python3-validity.udev 60-python-validity.rules
}

pkg_postinst() {
	elog "Sample configurations are available at:"
	elog "http://mmonit.com/monit/documentation/"
}