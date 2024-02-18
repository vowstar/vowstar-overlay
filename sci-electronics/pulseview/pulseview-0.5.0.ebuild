# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

GIT_COMMIT="ae8dd87"

inherit cmake xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="http://sigrok.org/gitweb/?p=${PN}.git;a=snapshot;h=${GIT_COMMIT};sf=zip -> ${PN}-${GIT_COMMIT}.zip"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="https://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode static"

BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	>=dev-cpp/glibmm-2.28.0:2
	dev-libs/boost:=
	>=dev-libs/glib-2.28.0:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	>=sci-libs/libsigrok-0.6.0:=[cxx]
	decode? ( >=sci-libs/libsigrokdecode-0.6.0:= )
"
DEPEND="${RDEPEND}"

DOCS=( HACKING NEWS README )

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory manual
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		-DENABLE_DECODE=$(usex decode)
		-DSTATIC_PKGDEPS_LIBS=$(usex static)
	)
	cmake_src_configure
}
