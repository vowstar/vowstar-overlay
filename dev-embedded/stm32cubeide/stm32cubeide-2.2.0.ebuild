# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev wrapper xdg

MY_BUILD="29186_20260626_0934"
MY_SH="stm32cubeide_${PV}_${MY_BUILD}-Lin-Deb-x86_64.sh"

DESCRIPTION="Integrated development environment for STM32 microcontrollers"
HOMEPAGE="https://www.st.com/en/development-tools/stm32cubeide.html"
SRC_URI="stm32cubeide_${PV}-Lin-Deb-x86_64.sh.zip"

S="${WORKDIR}"

LICENSE="SLA0048 jlink? ( SEGGER )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+stlink-server +udev jlink"

BDEPEND="
	app-arch/unzip
	sys-devel/binutils
"
RDEPEND="
	app-accessibility/at-spi2-core
	app-shells/bash
	dev-libs/glib:2
	gui-libs/gtk:4
	media-libs/freetype
	net-libs/webkit-gtk:4.1
	virtual/opengl
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	jlink? ( !dev-embedded/jlink )
	stlink-server? ( virtual/libusb:1 )
	udev? ( virtual/udev )
"

RESTRICT="fetch mirror bindist strip"

QA_PREBUILT="*"

unpack_deb() {
	local deb="${1}" dest="${2}" work="${WORKDIR}"/deb-$(basename "${deb}" .deb)
	local member

	mkdir -p "${work}" "${dest}" || die
	pushd "${work}" > /dev/null || die
	ar x "${deb}" || die "failed to extract ${deb}"

	for member in data.tar.*; do
		tar -xf "${member}" --no-same-owner -C "${dest}" \
			|| die "failed to unpack ${member}"
	done
	popd > /dev/null || die
}

src_unpack() {
	unpack "${A}"

	sh "${WORKDIR}"/${MY_SH} --noexec --keep --nox11 --quiet \
		--target "${WORKDIR}"/payload || die "failed to extract ${MY_SH}"
}

src_install() {
	local deb stage="${WORKDIR}"/stage

	for deb in "${WORKDIR}"/payload/stm32cubeide-*.deb; do
		unpack_deb "${deb}" "${ED}"
	done

	# the IDE expects stlink-server to be present, mirroring the deb dependencies
	for deb in "${WORKDIR}"/payload/st-stlink-udev-rules-*.deb \
		"${WORKDIR}"/payload/segger-jlink-udev-rules-*.deb \
		"${WORKDIR}"/payload/st-stlink-server-*.deb; do
		unpack_deb "${deb}" "${stage}"
	done

	if use udev; then
		udev_dorules "${stage}"/etc/udev/rules.d/49-stlinkv*.rules
	fi

	if use jlink; then
		udev_dorules "${stage}"/etc/udev/rules.d/99-jlink.rules
	fi

	if use stlink-server; then
		exeinto /usr/bin
		doexe "${stage}"/usr/bin/stlink-server
	fi

	make_wrapper ${PN} ./stm32cubeide_wayland /opt/st/stm32cubeide_${PV}
}

pkg_nofetch() {
	einfo "Download ${SRC_URI} from ${HOMEPAGE}"
	einfo "under Tools & Software (STM32CubeIDE, Debian Linux) and place it in DISTDIR."
	einfo "ST requires a registration before the download is offered."
}

pkg_postinst() {
	if use udev; then
		udev_reload
	fi

	xdg_desktop_database_update
}

pkg_postrm() {
	if use udev; then
		udev_reload
	fi

	xdg_desktop_database_update
}
