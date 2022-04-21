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
KEYWORDS="~amd64 ~arm64 ~mips ~x86"

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
	export AGREE_EULA="y"
	export CONTINUE_INSTALL="y"
	export PAGER="$(which cat)"

	# Fix printer install path
	sed -i "s#\"/opt\"#\"${D}/opt\"#g" noarch/package_utils
	sed -i "s#\"/opt\"#\"${D}/opt\"#g" noarch/pre_install.sh
	sed -i "s#\"\$INSTDIR_CUPS_BACKENDS\"#\"${D}/\$INSTDIR_CUPS_BACKENDS\"#g" noarch/printer.pkg
	sed -i "s#\"\$INSTDIR_CUPS_FILTERS\"#\"${D}/\$INSTDIR_CUPS_FILTERS\"#g" noarch/printer.pkg
	sed -i "s#\"\$INSTDIR_CUPS_PPD\"#\"${D}/\$INSTDIR_CUPS_PPD\"#g" noarch/printer-script.pkg
	sed -i "s#\"\$INSTDIR_LSB_PPD\"#\"${D}/\$INSTDIR_LSB_PPD\"#g" noarch/printer-script.pkg

	# Fix scanner install path
	sed -i "s#SANE_DIR=/usr/lib\${LIBSFX}/sane#SANE_DIR=${D}/usr/lib\${LIBSFX}/sane#g" noarch/scanner.pkg
	sed -i "s#/usr/lib/sane#${D}/usr/lib\${LIBSFX}/sane#g" noarch/scanner.pkg
	sed -i "s#\"\$INSTDIR_COMMON_SCANNER_SHARE\"#\"${D}/\$INSTDIR_COMMON_SCANNER_SHARE\"#g" noarch/scanner.pkg

	if use scanner ; then
		sh ./install.sh || die
	else
		sh ./install-printer.sh || die
	fi
}

pkg_postinst() {
	if use scanner ; then
		ewarn "If you want to use the scanner,"
		ewarn "make sure the smfp is listed in /etc/sane.d/dll.conf."
		ewarn "If the geniusvp2 is listed in /etc/sane.d/dll.conf,"
		ewarn "please comment out it."
	fi
}

pkg_postrm() {
	if use scanner ; then
		ewarn "If the smfp is listed in /etc/sane.d/dll.conf,"
		ewarn "please remove it."
	fi
}
