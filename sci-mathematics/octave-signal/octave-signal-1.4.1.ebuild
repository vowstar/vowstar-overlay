# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Signal processing tools, including filtering, windowing and display functions."
HOMEPAGE="https://octave.sourceforge.io/${PN}"
SRC_URI="https://downloads.sourceforge.net/octave/${P/octave-/}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
RESTRICT="test"

RDEPEND="sci-mathematics/octave"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/octave-/}"

src_install() {
	local INSTALL_PREFIX = "${D}/usr/share/octave/packages"
	local INSTALL_ARCHPREFIX = "${D}/usr/$(get_libdir)/octave/packages"
	octave --no-history --no-init-file --no-window-system -q -f --eval \
		"pkg local_list octave_packages;pkg prefix ${INSTALL_PREFIX} ${INSTALL_ARCHPREFIX};pkg install -verbose -nodeps ${DISTDIR}/${P}.tar.gz" || die
}

pkg_postinst() {
	einfo "Update Octave internal packages cache"
	octave --no-history --no-init-file --no-window-system -q -f --eval "pkg('rebuild');" || die
}

pkg_postrm() {
	einfo "Update Octave internal packages cache"
	octave --no-history --no-init-file --no-window-system -q -f --evall "pkg('rebuild');" || die
}