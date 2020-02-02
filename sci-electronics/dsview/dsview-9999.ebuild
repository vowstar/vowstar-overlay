# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools cmake-utils python-r1

DESCRIPTION="An open source multi-function instrument"
HOMEPAGE="
	https://www.dreamsourcelab.com
	https://github.com/DreamSourceLab/DSView
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git@github.com:DreamSourceLab/DSView.git"
else
	SRC_URI="https://github.com/DreamSourceLab/DSView/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	virtual/libusb:1
	>=dev-libs/libzip-0.8
"

DEPEND="
	${RDEPEND}
"

src_prepare() {
	cd "${WORKDIR}/libsigrok4DSL" || die
	sh ./autogen.sh || die
	cd "${WORKDIR}/libsigrokdecode4DSL" || die
	sh ./autogen.sh || die
}

src_configure() {
	cd "${WORKDIR}/libsigrok4DSL" || die
	sh ./configure || die
	cd "${WORKDIR}/libsigrokdecode4DSL" || die
	sh ./configure || die
}

src_compile() {
	cd "${WORKDIR}/libsigrok4DSL" || die
	emake DESTDIR="${D}"
	cd "${WORKDIR}/libsigrokdecode4DSL" || die
	emake DESTDIR="${D}"
}

src_install() {
	cd "${WORKDIR}/libsigrok4DSL" || die
	emake DESTDIR="${D}" install
	cd "${WORKDIR}/libsigrokdecode4DSL" || die
	emake DESTDIR="${D}" install
	cd "${WORKDIR}/DSView" || die
	cmake . || die
	emake DESTDIR="${D}" install
}
