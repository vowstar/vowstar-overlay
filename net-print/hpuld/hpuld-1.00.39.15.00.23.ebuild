# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PY="$(ver_rs 4 _)"

DESCRIPTION="HP Unified Linux Driver (for samsung hardware)"
HOMEPAGE="https://support.hp.com"

SRC_URI="
	https://ftp.ext.hp.com/pub/softlib/software13/printers/LaserJet/M437_M443/ULDLINUX_HewlettPackard_V${MY_PY}.zip
"

S="${WORKDIR}/uld"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

IUSE="+scanner"

RDEPEND="
	net-print/cups
	scanner? (
		media-gfx/sane-backends
	)
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	app-arch/unzip
"

src_unpack() {
	default

	for f in ${WORKDIR}/*/*.tar.gz; do
		tar -zxf "$f" -C ${WORKDIR} || die
	done
}

src_install() {
	sh ./install.sh || die
}
