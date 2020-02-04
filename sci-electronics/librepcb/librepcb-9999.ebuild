# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg-utils

DESCRIPTION="Free EDA GUI software to develop printed circuit boards"
HOMEPAGE="
	https://librepcb.org
	https://github.com/LibrePCB/LibrePCB
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LibrePCB/LibrePCB.git"
else
	SRC_URI="https://github.com/LibrePCB/LibrePCB/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	S="${WORKDIR}/LibrePCB-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtxml:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtconcurrent:5
	sys-libs/zlib
	dev-libs/openssl
"

RDEPEND="
	${DEPEND}
"

BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5
"

src_configure() {
	# Can't use default, call emake5 to generate Makefile
	eqmake5 -r ${PN}.pro PREFIX="/usr"
}

src_install() {
	# Can't use default, need set INSTALL_ROOT
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
