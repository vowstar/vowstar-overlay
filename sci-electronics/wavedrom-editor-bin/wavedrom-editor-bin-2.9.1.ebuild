# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"
inherit desktop unpacker xdg

DESCRIPTION="Digital timing diagram editor"
HOMEPAGE="
	https://wavedrom.com
	https://github.com/wavedrom/wavedrom.github.io
"

SRC_URI="
	https://github.com/wavedrom/wavedrom.github.io/releases/download/v${PV}/${MY_PN}-v${PV}-linux-x64.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libxshmfence
	x11-libs/libXtst
	x11-libs/pango
"

DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	gnome-base/librsvg
"

S="${WORKDIR}/${MY_PN}-v${PV}-linux-x64"

QA_PREBUILT="
	opt/${MY_PN}/${MY_PN}
	opt/${MY_PN}/chrome_crashpad_handler
	opt/${MY_PN}/lib/libEGL.so
	opt/${MY_PN}/lib/libffmpeg.so
	opt/${MY_PN}/lib/libGLESv2.so
	opt/${MY_PN}/lib/libnode.so
	opt/${MY_PN}/lib/libnw.so
	opt/${MY_PN}/lib/libvk_swiftshader.so
	opt/${MY_PN}/lib/libvulkan.so.1
	opt/${MY_PN}/swiftshader/libEGL.so
	opt/${MY_PN}/swiftshader/libGLESv2.so
"

src_install() {
	insinto /opt/"${MY_PN}"
	doins -r *
	local f
	for f in ${QA_PREBUILT}; do
		fperms +x "/${f}"
	done

	dosym ../../opt/"${MY_PN}"/"${MY_PN}" /usr/bin/"${MY_PN}"

	# desktop file
	domenu "${FILESDIR}"/"${MY_PN}".desktop
	# icon
	doicon -s scalable "${FILESDIR}"/"${MY_PN}".svg
	for i in 16 22 24 32 36 48 64 72 96 128 192 256 512; do
		mkdir "${T}/${i}x${i}" || die
		rsvg-convert -a -f png -w "${i}" -o "${T}/${i}x${i}/${PN}.png" "${FILESDIR}"/"${MY_PN}".svg || die
		doicon -s "${i}" "${T}/${i}x${i}/${MY_PN}.png"
	done
}
