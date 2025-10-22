# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_P="${PN}-v${PV}"

DESCRIPTION="Kose Font (小赖字体) - An open-source Chinese font"
HOMEPAGE="https://github.com/lxgw/kose-font"
SRC_URI="
	https://github.com/lxgw/kose-font/releases/download/v${PV}/Xiaolai-Regular.ttf
	https://github.com/lxgw/kose-font/releases/download/v${PV}/XiaolaiMono-Regular.ttf
"

# Has to fall back to distdir until author offers tarball
S="${DISTDIR}"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"

FONT_SUFFIX="ttf"
FONT_S="${DISTDIR}"
