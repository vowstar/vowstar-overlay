# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

MY_PN="${PN%-bin}"
MY_PV="${PV//./-}"

DESCRIPTION="Block diagram simulator for power electronics and electrical systems"
HOMEPAGE="https://www.plexim.com/products/plecs/plecs_standalone"
SRC_URI="https://www.plexim.com/sites/default/files/packages/${MY_PN}-standalone-${MY_PV}_linux64.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="Plexim-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip test"

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-fonts/dejavu
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng:0
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	virtual/libudev
	virtual/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxshmfence
	x11-libs/libXtst
"
DEPEND="${RDEPEND}"

QA_PREBUILT="opt/${MY_PN}/*"

src_install() {
	local target="/opt/${MY_PN}"

	insinto "${target}"
	doins -r .

	fperms 0755 "${target}"/PLECS
	fperms 0755 "${target}"/PLECS.bin
	fperms 0755 "${target}"/PLECS_server
	fperms 0755 "${target}"/PLECS_server.bin
	fperms 0755 "${target}"/QtWebEngineProcess
	fperms 0755 "${target}"/crashreporter
	fperms 0755 "${target}"/crashreporter.bin
	fperms 0755 "${target}"/qhelpgenerator
	fperms 0755 "${target}"/qhelpgenerator.bin
	fperms 0755 "${target}"/webengine
	fperms 0755 "${target}"/webengine.bin

	# Upstream's PLECS shell wrapper resolves its sibling .bin via $0, so a
	# /usr/bin symlink would make it look for /usr/bin/plecs.bin. Install
	# thin wrappers that invoke the real launcher by absolute path.
	cat > "${T}"/plecs <<-EOF || die
		#!/bin/sh
		exec "${target}"/PLECS "\$@"
	EOF
	cat > "${T}"/plecs-server <<-EOF || die
		#!/bin/sh
		exec "${target}"/PLECS_server "\$@"
	EOF
	dobin "${T}"/plecs "${T}"/plecs-server

	doicon -s scalable "${FILESDIR}/${MY_PN}.svg"
	domenu "${FILESDIR}/${MY_PN}.desktop"
}
