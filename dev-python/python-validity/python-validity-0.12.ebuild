# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1 systemd

DESCRIPTION="Validity fingerprint sensor prototype"
HOMEPAGE="https://github.com/uunicorn/python-validity"
SRC_URI="https://github.com/uunicorn/${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"

IUSE="systemd"

KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-auth/fprintd-clients
	sys-auth/open-fprintd
"

DEPEND="
	${RDEPEND}
"

src_install() {
	default
	systemd_dounit "${S}"/debian/python3-validity.service
	udev_newrules "${S}"/debian/python3-validity.udev 60-python-validity.rules
}
