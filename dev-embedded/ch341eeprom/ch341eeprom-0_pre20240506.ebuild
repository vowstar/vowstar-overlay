# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="libusb based programming tool for 24Cxx EEPROMs via CH341A"
HOMEPAGE="https://github.com/command-tab/ch341eeprom"

EGIT_COMMIT="7cffbef7552d93162bd90cae836a45e94acb93fb"
SRC_URI="https://github.com/command-tab/ch341eeprom/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	acct-group/plugdev
	virtual/libusb:1
"
DEPEND="${RDEPEND}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		-o ch341eeprom ch341eeprom.c ch341funcs.c -lusb-1.0 || die
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
		-o mktestimg mktestimg.c || die
}

src_install() {
	dobin ch341eeprom mktestimg
	udev_dorules 99-CH341.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload

	elog "To access the CH341A programmer as a regular user you must"
	elog "be a member of the 'plugdev' group."
}

pkg_postrm() {
	udev_reload
}
