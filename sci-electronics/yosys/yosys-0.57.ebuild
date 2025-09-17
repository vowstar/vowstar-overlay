# Copyright 1999-2025 Gentoo Authors

EAPI=8

DESCRIPTION="framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="
	https://github.com/YosysHQ/${PN}/releases/download/v${PV}/yosys.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/boost
	media-gfx/xdot
	llvm-core/clang
"

DEPEND="${RDEPEND}"
BDEPEND="dev-vcs/git"

QA_PRESTRIPPED="
	/usr/bin/yosys-filterlib
	/usr/bin/yosys-abc
"

src_install() {
	emake DESTDIR="${D}" PREFIX='/usr' install
}
