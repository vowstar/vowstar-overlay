# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of routines to export data produced by Finite Elements or Finite Volume Simulations in formats used by some visualization programs"
HOMEPAGE="https://octave.sourceforge.io/fpl"
SRC_URI="https://downloads.sourceforge.net/octave/${P/octave-/}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
RESTRICT="test"

RDEPEND="sci-mathematics/octave"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/octave-/}"

src_install() {
	local INST_PREFIX="${D}/usr/share/octave/packages"
	local ARCH_PREFIX="${D}/usr/$(get_libdir)/octave/packages"

	octave --no-history --no-init-file --no-site-file --no-window-system -q -f \
		--eval "warning off all;\
		pkg prefix ${INST_PREFIX} ${ARCH_PREFIX};\
		pkg local_list octave_packages;\
		pkg global_list octave_packages;\
		pkg install -verbose -nodeps ${DISTDIR}/${P}.tar.gz;" || die
}

pkg_postinst() {
	einfo "Updating Octave internal packages cache..."
	octave --no-history --no-init-file --no-site-file --no-window-system -q -f \
		--eval "pkg rebuild;" || die
	elog "Please append 'pkg load ${PN/octave-/}' to ~/.octaverc"
}

pkg_postrm() {
	einfo "Updating Octave internal packages cache..."
	octave --no-history --no-init-file --no-site-file --no-window-system -q -f \
		--eval "pkg rebuild;" || die
	elog "Please remove 'pkg load ${PN/octave-/}' to ~/.octaverc"
}