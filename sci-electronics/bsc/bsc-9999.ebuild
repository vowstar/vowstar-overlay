# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Bluespec High Level Hardware Design Language"
HOMEPAGE="https://github.com/B-Lang-org/bsc"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/B-Lang-org/${PN}.git"
else
	SRC_URI=""
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
fi

LICENSE="BSD GPL-3+ MIT"
SLOT="0"

DEPEND="
	>=dev-haskell/cabal-1.6:=[profile?]
	>=dev-haskell/old-time-1.1:=[profile?]
	>=dev-haskell/regex-compat-0.95.1:=[profile?]
	>=dev-haskell/syb-0.1:=[profile?]
	media-libs/fontconfig
	x11-libs/libXft
"

RDEPEND="
	${DEPEND}
"

BDEPEND="
	>=dev-lang/ghc-6.12.1
	dev-util/gperf
"

src_configure() {
	echo "Skip configure" || die
}

src_compile() {
	echo "Skip compile" || die
}

src_install() {
	emake PREFIX="${D}/usr/bin"
}
