# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_P="${PN}-v${PV}"

DESCRIPTION="Yozai (悠哉字体) - A Chinese font derived from Y.OzFont"
HOMEPAGE="https://github.com/lxgw/yozai-font"
SRC_URI="
	https://github.com/lxgw/yozai-font/releases/download/v${PV}/Yozai-Light.ttf
	https://github.com/lxgw/yozai-font/releases/download/v${PV}/Yozai-Medium.ttf
	https://github.com/lxgw/yozai-font/releases/download/v${PV}/Yozai-Regular.ttf
"

# Has to fall back to distdir until author offers tarball
S="${DISTDIR}"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"

FONT_SUFFIX="ttf"
FONT_S="${DISTDIR}"
