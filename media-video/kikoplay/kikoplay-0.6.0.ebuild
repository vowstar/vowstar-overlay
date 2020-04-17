# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GIT_PN="KikoPlay"

inherit qmake-utils xdg

DESCRIPTION="KikoPlay is a full-featured danmu player"
HOMEPAGE="
	https://kikoplay.fun
	https://github.com/Protostars/KikoPlay
"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Protostars/${GIT_PN}.git"
else
	SRC_URI="https://github.com/Protostars/${GIT_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
	S="${WORKDIR}/${GIT_PN}-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-lang/lua:5.3
	dev-libs/qhttpengine:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	media-video/mpv[libmpv,-luajit]
"

DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	# Fix lua link problem, link to lua5.3 to fix bug
	sed -i "s/-llua/-llua5.3/" KikoPlay.pro || die "Could not fix lua link"
	echo "CONFIG += ordered" >> KikoPlay.pro || die "Could not fix parallel bug"
}

src_configure() {
	eqmake5 PREFIX="${D}"/usr
}
