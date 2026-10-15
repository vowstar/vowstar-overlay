# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

# the installer names its payload with the patch separator replaced by an underscore
MY_EXE="SetupSTM32CubeMX-${PV%.*}_${PV##*.}"

DESCRIPTION="Graphical configuration tool for STM32 microcontrollers"
HOMEPAGE="https://www.st.com/en/development-tools/stm32cubemx.html"
SRC_URI="SetupSTM32CubeMX-${PV}-Lin-x86_64.zip"

S="${WORKDIR}"

LICENSE="SLA0048"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/pango
"

RESTRICT="fetch mirror bindist strip"

QA_PREBUILT="*"

src_install() {
	local mxdir="${ED}"/opt/st/stm32cubemx-${PV}

	dodir /opt/st

	printf 'INSTALL_PATH=%s\n' "${mxdir}" > "${WORKDIR}"/install-options.txt || die

	# the IZPack payload ships its own jre next to the installer binary
	"${WORKDIR}"/${MY_EXE} -options "${WORKDIR}"/install-options.txt \
		|| die "unattended installation failed"

	# IZPack uninstaller and its data, which record the build time install path
	rm -rf "${mxdir}"/.installationinformation "${mxdir}"/Uninstaller || die

	newicon -s 256 "${mxdir}"/help/STM32CubeMX.png stm32cubemx.png
	make_desktop_entry ${PN} "STM32CubeMX" ${PN} "Development;Electronics"
	make_wrapper ${PN} ./STM32CubeMX /opt/st/stm32cubemx-${PV}
}

pkg_nofetch() {
	einfo "Download ${SRC_URI} from ${HOMEPAGE}"
	einfo "under Tools & Software (STM32CubeMX, Linux) and place it in DISTDIR."
	einfo "ST requires a registration before the download is offered."
}

pkg_postinst() {
	elog "Upgrade this package through portage. The installer's own updater and"
	elog "uninstaller are not included."

	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
