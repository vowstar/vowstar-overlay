# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="openEMS"

DESCRIPTION="Free and open electromagnetic field solver using the FDTD method"
HOMEPAGE="https://openems.de https://github.com/thliebig/openEMS"
SRC_URI="https://github.com/thliebig/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="mpi"

RDEPEND="
	dev-libs/boost:=
	dev-libs/tinyxml
	sci-libs/csxcad
	sci-libs/fparser
	sci-libs/hdf5:=[mpi=]
	sci-libs/vtk:=
	mpi? ( virtual/mpi )
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
		-DWITH_MPI=$(usex mpi)
	)
	cmake_src_configure
}
