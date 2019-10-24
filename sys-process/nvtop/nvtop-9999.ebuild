# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	#inherit vcs-snapshot
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
    mkdir -p ${BUILD_DIR}/include
	cp -f ${FILESDIR}/nvml.h ${BUILD_DIR}/include/nvml.h
    cp -f ${FILESDIR}/FindCurses.cmake ${WORKDIR}/${P}/cmake/modules/FindCurses.cmake
}

src_configure() {
    # general configuration
    mkdir -p ${BUILD_DIR}
    cd ${BUILD_DIR}
    cmake ${CMAKE_CONF} ${WORKDIR}/${P}
}

src_compile() {
    cd ${BUILD_DIR}
    emake
}

src_install() {
    cd ${BUILD_DIR}
    emake DESTDIR="${D}" install
    prepgamesdirs
}
