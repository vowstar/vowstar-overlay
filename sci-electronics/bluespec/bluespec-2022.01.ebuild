# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Toolchain for the Bluespec Hardware Definition Language"
HOMEPAGE="https://github.com/B-Lang-org/bsc"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/B-Lang-org/bsc.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/B-Lang-org/bsc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/SRI-CSL/yices2/archive/refs/tags/Yices-2.6.4.tar.gz -> yices-2.6.4.tar.gz
	"
	S="${WORKDIR}/bsc-${PV}"
	S_YICES="${WORKDIR}/yices2-Yices-2.6.4"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD GPL-3+ MIT"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-haskell/old-time:0=
	dev-haskell/regex-compat:0=
	dev-haskell/split:0=
	dev-haskell/syb:0=
	dev-lang/tcl
"

DEPEND="
	${RDEPEND}
	test? (
		dev-util/dejagnu
		sci-electronics/iverilog
		sci-electronics/systemc
		sys-process/time
	)
"

BDEPEND="
	dev-haskell/cabal:0=
	dev-lang/ghc:0=
	dev-lang/perl
	dev-util/gperf
	doc? (
		app-text/asciidoc
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
	)
	sys-devel/autoconf
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2022.01-libstp-stub-makefile.patch
)

DOCS=( "README.md" "COPYING" )

src_prepare() {
	if [[ ${PV} != "9999" ]] ; then
		rm -r "${S}"/src/vendor/yices/v2.6/yices2 || die
		ln -s "${S_YICES}" "${S}"/src/vendor/yices/v2.6/yices2 || die
	fi

	default
}

# The upstream will install while compiling, even if we don't execute
# make install here, this seems to be an upstream bug.
src_compile() { :; }

src_install() {
	# PREFIX="${EPREFIX}"/usr/share/bsc/bsc-"${PV}": https://github.com/B-Lang-org/bsc/blob/main/INSTALL.md
	# NO_DEPS_CHECKS=1: skip the subrepo check (this deriviation uses yices.src instead of the subrepo)
	# NOGIT=1: https://github.com/B-Lang-org/bsc/issues/12
	# LDCONFIG=ldconfig: https://github.com/B-Lang-org/bsc/pull/43
	# STP_STUB=1: https://github.com/B-Lang-org/bsc/pull/278
	emake PREFIX="${ED}"/usr/share/bsc/bsc-"${PV}" \
		"release" \
		"NO_DEPS_CHECKS=1" \
		"NOGIT=1" \
		"LDCONFIG=ldconfig" \
		"STP_STUB=1" \
		$(usex doc "" "NOASCIIDOCTOR=1") \
		$(usex doc "install-doc" "") \
		$(usex doc "install-release" "") \
		install-src \
		$(usex doc "release" "")
	emake -C src/comp PREFIX="${ED}"/usr/share/bsc/bsc-"${PV}" \
		install-extra

	einstalldocs
}