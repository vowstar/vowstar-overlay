# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake python-r1

DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://gitlab.inria.fr/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.inria.fr/${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="mpi mysql +curl +hwloc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	!sci-mathematics/ggnfs
	mpi? ( virtual/mpi )
	mysql? ( virtual/mysql )
	curl? ( net-misc/curl )
	hwloc? ( >=sys-apps/hwloc-2.0.0 )
	dev-libs/gmp:0=
"

DEPEND="
	dev-util/cmake
	${RDEPEND}
"

BUILD_DIR="${WORKDIR}/build"

src_prepare() {
	default
	cmake_src_prepare

	if use mpi ; then
		echo "MPI=1" >> local.sh || die
	else
		echo "MPI=0" >> local.sh || die
	fi
	# Enable -O2 -DNDEBUG options
	echo "CFLAGS=-O2 -DNDEBUG" >> local.sh || die
	echo "CXXFLAGS=-O2 -DNDEBUG" >> local.sh || die

	# install all lib to lib64 dir
	sed -i -e 's/LIBSUFFIX lib/LIBSUFFIX lib64/' CMakeLists.txt || die
	# workaround ABI=amd64 compile problem
	sed -i -e 's/x$ABI/xdefault/' gf2x/configure.ac || die
	sed -i -e 's/x$ABI/xdefault/' gf2x/configure || die

	# workaround libraries not found problem
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/filter"' CMakeLists.txt || die
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/linalg"' CMakeLists.txt || die
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/misc"' CMakeLists.txt || die
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/numbertheory"' CMakeLists.txt || die
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/sieve"' CMakeLists.txt || die
	sed -i '/string_join(rpath ":"/a         "${CMAKE_INSTALL_PREFIX}/${LIBSUFFIX}/sqrt"' CMakeLists.txt || die

	sed -i '/add_library(plingen_${v}_support ${plingen_${v}_support_sources})/a                 install(TARGETS plingen_${v}_support DESTINATION ${LIBSUFFIX}/linalg/bwc)' linalg/bwc/CMakeLists.txt || die
	sed -i '/add_library(flint-fft ${flint_fft_files})/a     install(TARGETS flint-fft DESTINATION ${LIBSUFFIX}/linalg/bwc)' linalg/bwc/CMakeLists.txt || die

	echo 'install(TARGETS bitlinalg DESTINATION ${LIBSUFFIX}/linalg)' >> linalg/CMakeLists.txt || die
	echo 'install(TARGETS trialdiv DESTINATION ${LIBSUFFIX}/sieve)' >> sieve/CMakeLists.txt || die
	echo 'install(TARGETS facul DESTINATION ${LIBSUFFIX}/sieve)' >> sieve/ecm/CMakeLists.txt || die

	if [[ ${PV} == "9999" ]] ; then
		# workaround c++ compile problem for non-type template parameters
		# sed -i -e 's/std=c++11/std=c++2a/' CMakeLists.txt || die
		# sed -i -e 's/std=c++11/std=c++2a/' gf2x/Makefile.in || die
		# sed -i -e 's/std=c++11/std=c++2a/' gf2x/Makefile.am || die
		# link with gomp to fix compile problem
		sed -i -e 's/utils pthread/utils pthread gomp/' utils/CMakeLists.txt || die
	else
		# looks like packaging mistake
		#sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
		#sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
		#sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die

		# link with gomp to fix compile problem
		sed -i -e 's/utils pthread/utils pthread gomp/' utils/CMakeLists.txt || die
		# edit code to fit hwloc 2.0.0
		sed -i -e 's/flags &= ~(HWLOC_TOPOLOGY_FLAG_IO_DEVICES | HWLOC_TOPOLOGY_FLAG_IO_BRIDGES);//' linalg/bwc/cpubinding.cpp || die
		sed -i -e 's/hwloc_topology_set_flags(topology, flags)/hwloc_topology_set_io_types_filter(topology, HWLOC_TYPE_FILTER_KEEP_ALL)/' linalg/bwc/cpubinding.cpp || die
		# workaround libraries not found problem
		echo 'install(TARGETS las-norms DESTINATION ${LIBSUFFIX}/sieve)' >> sieve/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	)

	# Install shared library, and set correctly RPATH
	export ENABLE_SHARED=1 || die

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	#find "${WORKDIR}/build" | grep -e "so$" | xargs -I{} dolib.so {}  || die
}
