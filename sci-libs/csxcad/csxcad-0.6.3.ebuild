# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="CSXCAD"

DESCRIPTION="C++ geometry library used by the openEMS FDTD solver"
HOMEPAGE="https://github.com/thliebig/CSXCAD"
SRC_URI="https://github.com/thliebig/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/boost:=
	dev-libs/tinyxml
	sci-libs/fparser
	sci-libs/hdf5:=
	sci-libs/vtk:=
	sci-mathematics/cgal:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Boost >=1.69 made the system library header-only; drop it from the
	# component list so find_package(Boost) succeeds on modern Boost.
	sed -i -e '/^[[:space:]]*system$/d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBoost_NO_BOOST_CMAKE=ON
	)
	cmake_src_configure
}
