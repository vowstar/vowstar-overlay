# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="NVIDIA GPUs htop like monitoring tool"
HOMEPAGE="https://github.com/Syllo/nvtop"
LICENSE="GPL-3"
SLOT="0"
IUSE="unicode debug"

RDEPEND="
    sys-libs/ncurses:0=[unicode?]
    dev-util/cmake
    dev-vcs/git
    x11-drivers/nvidia-drivers
"

DEPEND="${RDEPEND}"

BUILD_DIR="${WORKDIR}/build"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Syllo/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Syllo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~hppa ~m68k ~mips ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

CMAKE_CONF="
    !debug? ( -DCMAKE_BUILD_TYPE=Release )
    debug? ( -DCMAKE_BUILD_TYPE=Debug )
    unicode? ( -DCURSES_NEED_WIDE=TRUE )
"

src_prepare() {
    default
    cmake-utils_src_prepare
    mkdir -p ${BUILD_DIR}/include
	cp -f ${FILESDIR}/nvml.h ${BUILD_DIR}/include/nvml.h
    cp -f ${FILESDIR}/FindCurses.cmake ${WORKDIR}/${P}/cmake/modules/FindCurses.cmake
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
        ${CMAKE_CONF}
	)

    cmake-utils_src_configure
}

src_compile() {
    cmake-utils_src_compile
}

src_install() {
    cmake-utils_src_install
}
