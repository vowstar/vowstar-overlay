# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OpenSTA - Static Timing Analyzer"
HOMEPAGE="https://github.com/parallaxsw/OpenSTA"

# Version from CMakeLists.txt: project(STA VERSION 2.7.0)
# Commit: 7ac4a47db1deeab3b40adb87be4398cb031f95be (2025-12-12)
COMMIT="7ac4a47db1deeab3b40adb87be4398cb031f95be"
SRC_URI="https://github.com/parallaxsw/OpenSTA/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenSTA-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="tclreadline"

RDEPEND="
	dev-lang/tcl:0=
	dev-cpp/eigen:3
	sci-mathematics/cudd
	tclreadline? ( dev-tcltk/tclreadline )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	app-alternatives/lex
	app-alternatives/yacc
"

src_prepare() {
	# Fix hardcoded lib path for multilib
	sed -i 's|DESTINATION lib)|DESTINATION ${CMAKE_INSTALL_LIBDIR})|g' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCUDD_DIR="${EPREFIX}/usr"
		-DUSE_TCL_READLINE=$(usex tclreadline ON OFF)
	)
	cmake_src_configure
}
