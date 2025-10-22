# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="LxgwMarkerGothic"

DESCRIPTION="An open-source Chinese font derived from Tanugo"
HOMEPAGE="https://github.com/lxgw/LxgwMarkerGothic"
SRC_URI="
	https://github.com/lxgw/${MY_PN}/releases/download/v${PV}/${MY_PN}-v${PV}.zip
"

S="${WORKDIR}/${MY_PN}-v${PV}"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

src_install() {
	FONT_S="${S}/fonts/ttf" font_src_install
}
