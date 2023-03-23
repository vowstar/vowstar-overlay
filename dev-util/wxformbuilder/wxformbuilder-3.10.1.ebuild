# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE="Release"
WX_GTK_VER="3.2-gtk3"

inherit cmake wxwidgets xdg

DESCRIPTION="A wxWidgets GUI Builder"
HOMEPAGE="https://github.com/wxFormBuilder/wxFormBuilder"

SRC_URI="https://github.com/wxFormBuilder/wxFormBuilder/releases/download/v${PV}/wxFormBuilder-${PV}-source-full.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/wxFormBuilder-${PV}"
PATCHES=(
	"${FILESDIR}/${P}-auitabart.patch"
)

src_prepare() {
	cmake_src_prepare
}
