# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Verilog simulation and synthesis tool"
HOMEPAGE="http://iverilog.icarus.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="examples"

RDEPEND="
	app-arch/bzip2
	sys-libs/readline:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

GITHUB_PV=$(ver_rs 1- '_')

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/steveicarus/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/steveicarus/${PN}/archive/v${GITHUB_PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~hppa ~m68k ~mips ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	dodoc *.txt

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
