# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} pypy3 )

inherit distutils-r1

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