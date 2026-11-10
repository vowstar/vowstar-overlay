# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="solidcraft"

inherit desktop xdg

DESCRIPTION="Open-source parametric 3D CAD application built in Rust"
HOMEPAGE="
	https://solidcraft.io
	https://github.com/tangency-labs/solidcraft
"

SRC_URI="
	amd64? (
		https://github.com/tangency-labs/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}-linux-x86_64.tar.gz
			-> ${P}-x86_64.tar.gz
	)
	arm64? (
		https://github.com/tangency-labs/${MY_PN}/releases/download/v${PV}/${MY_PN}-${PV}-linux-aarch64.tar.gz
			-> ${P}-aarch64.tar.gz
	)
"

case ${ARCH} in
	amd64) S="${WORKDIR}/${MY_PN}-${PV}-linux-x86_64" ;;
	arm64) S="${WORKDIR}/${MY_PN}-${PV}-linux-aarch64" ;;
esac

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RESTRICT="mirror strip"
QA_PREBUILT="*"

RDEPEND="
	dev-libs/wayland
	media-libs/mesa
	|| (
		media-libs/libglvnd
		media-libs/vulkan-loader
	)
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/libxkbcommon[X]
"

src_install() {
	exeinto /usr/bin
	doexe bin/solidcraft bin/solidcraft-cli bin/solvecraft-cli

	domenu share/applications/io.tangencylabs.solidcraft.desktop

	insinto /usr/share/metainfo
	doins share/metainfo/io.tangencylabs.solidcraft.metainfo.xml

	insinto /usr/share/mime/packages
	doins share/mime/packages/io.tangencylabs.solidcraft.xml

	insinto /usr/share/icons
	doins -r share/icons/hicolor

	dodoc share/doc/solidcraft/{README.md,NOTICE,LICENSE-APACHE,LICENSE-MIT,THIRD-PARTY-LICENSES.txt}
}
