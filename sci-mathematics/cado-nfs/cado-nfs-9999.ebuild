# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE="sqlite"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-utils python-r1

DESCRIPTION="Number Field Sieve (NFS) implementation for factoring integers"
HOMEPAGE="http://cado-nfs.gforge.inria.fr"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="mpi mysql curl hwloc"

RDEPEND="
	!sci-mathematics/ggnfs
	!sci-biology/shrimp
	mpi? ( virtual/mpi )
	mysql? ( virtual/mysql )
	curl? ( net-misc/curl )
	hwloc? ( >=sys-apps/hwloc-2.0.0 )
	dev-libs/gmp:0=
	${PYTHON_DEPS}
"

DEPEND="
	dev-util/cmake
	${RDEPEND}
"

BUILD_DIR="${WORKDIR}/build"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://scm.gforge.inria.fr/anonscm/git/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gforge.inria.fr/frs/download.php/file/37058/${P}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~hppa ~m68k ~mips ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

src_prepare() {
	default
	cmake-utils_src_prepare

	if [[ ${PV} == "9999" ]] ; then
	    # workaround ABI=amd64 compile problem
		sed -i -e 's/x$ABI/xdefault/' gf2x/configure.ac || die
		sed -i -e 's/x$ABI/xdefault/' gf2x/configure || die
		# workaround c++ compile problem for non-type template parameters
		sed -i -e 's/std=c++11/std=c++2a/' CMakeLists.txt || die
		sed -i -e 's/std=c++11/std=c++2a/' gf2x/Makefile.in || die
		sed -i -e 's/std=c++11/std=c++2a/' gf2x/Makefile.am || die
		# link with gomp to fix compile problem
		sed -i -e 's/utils pthread/utils pthread gomp/' utils/CMakeLists.txt || die
	else
		# looks like packaging mistake
		#sed -i -e 's/add_executable (convert_rels convert_rels.c)//' misc/CMakeLists.txt || die
		#sed -i -e 's/target_link_libraries (convert_rels utils)//' misc/CMakeLists.txt || die
		#sed -i -e 's~install(TARGETS convert_rels RUNTIME DESTINATION bin/misc)~~' misc/CMakeLists.txt || die
	    # workaround ABI=amd64 compile problem
		sed -i -e 's/x$ABI/xdefault/' gf2x/configure.ac || die
		sed -i -e 's/x$ABI/xdefault/' gf2x/configure || die
		# link with gomp to fix compile problem
		sed -i -e 's/utils pthread/utils pthread gomp/' utils/CMakeLists.txt || die
		# edit code to fit hwloc 2.0.0
		sed -i -e 's/flags &= ~(HWLOC_TOPOLOGY_FLAG_IO_DEVICES | HWLOC_TOPOLOGY_FLAG_IO_BRIDGES);//' linalg/bwc/cpubinding.cpp || die
		sed -i -e 's/hwloc_topology_set_flags(topology, flags)/hwloc_topology_set_io_types_filter(topology, HWLOC_TYPE_FILTER_KEEP_ALL)/' linalg/bwc/cpubinding.cpp || die
	fi

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
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	#find "${WORKDIR}/build" | grep -e "so$" | xargs -I{} cp -u {} "${EPREFIX}/usr/lib64" | die
}
