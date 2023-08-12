# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="Unofficial Microsoft Teams for Linux client"
HOMEPAGE="https://github.com/IsmaelMartinez/teams-for-linux"
SRC_URI="
	amd64? ( https://github.com/IsmaelMartinez/${PN}/releases/download/v${PV}/${PN}_${PV}_amd64.deb )
	arm64? ( https://github.com/IsmaelMartinez/${PN}/releases/download/v${PV}/${PN}_${PV}_arm64.deb )
"

# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 GPL-3 LGPL-2.1 APSL-2
	unRAR OFL CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core
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

S="${WORKDIR}"
QA_PREBUILT="opt/${PN}/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/${PN}/locales" || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	for size in {64,128}; do
		doicon -s ${size} "usr/share/icons/hicolor/${size}x${size}/apps/${PN}.png"
	done

	domenu "usr/share/applications/${PN}.desktop"

	local DESTDIR="/opt/${PN}"

	pushd "opt/${PN}" || die

	exeinto "${DESTDIR}"
	doexe chrome-sandbox "${PN}" *.so*

	insinto "${DESTDIR}"
	doins *.pak *.bin *.json *.dat
	insopts -m0755
	doins -r locales resources

	# Chrome-sandbox requires the setuid bit to be specifically set.
	# see https://github.com/electron/electron/issues/17972
	fperms 4755 "${DESTDIR}"/chrome-sandbox

	dosym "${DESTDIR}"/"${PN}" /usr/bin/"${PN}"
	popd || die
}
