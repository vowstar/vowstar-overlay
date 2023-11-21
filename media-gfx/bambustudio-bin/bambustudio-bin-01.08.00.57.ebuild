# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="BambuStudio"
WX_GTK_VER="3.0-gtk3"
CHECKREQS_DISK_BUILD="10G"

inherit check-reqs desktop unpacker wxwidgets xdg

DESCRIPTION="Bambu Studio is a cutting-edge, feature-rich slicing software"
HOMEPAGE="https://bambulab.com"

SRC_URI="
	https://github.com/bambulab/${MY_PN}/releases/download/v${PV}/Bambu_Studio_linux_ubuntu_v${PV}-20231109141031.AppImage -> ${P}.AppImage
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	media-gfx/openvdb
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/gstreamer
	media-libs/mesa[X(+)]
	net-libs/libsoup
	net-libs/webkit-gtk:4.1/0
	>=sci-libs/opencascade-7.3.0:0=
	virtual/glu
	>=x11-libs/cairo-1.8.8:=
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.30
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-vcs/git
"

QA_PREBUILT="*"
RESTRICT="strip"
S="${WORKDIR}/${P}"

src_unpack() {
	unpack_deb "${PN}-dep-webkit2gtk.deb"
	mkdir "${S}" || die
	cp "${DISTDIR}/${P}.AppImage" "${S}"/ || die
	pushd "${S}" || die
	chmod +x "${S}/${P}.AppImage" || die
	"${S}/${P}.AppImage" --appimage-extract || die
	rm "${S}/${P}.AppImage" || die
	popd || die
}

src_install() {
	rm "${S}"/squashfs-root/*.AppImage || die
	rm "${S}"/squashfs-root/*.desktop || die
	rm "${S}"/squashfs-root/.DirIcon || die
	rm -r "${S}"/squashfs-root/usr || die
	patchelf --replace-needed libwebkit2gtk-4.0.so.37 libwebkit2gtk-4.1.so.0 \
		"${S}"/squashfs-root/bin/bambu-studio || die
	patchelf --replace-needed libjavascriptcoregtk-4.0.so.18 libjavascriptcoregtk-4.1.so.0 \
		"${S}"/squashfs-root/bin/bambu-studio || die
	insinto /opt/"${PN}"
	doins -r "${S}"/squashfs-root/*
	fperms +x "/opt/${PN}/AppRun" "/opt/${PN}/bin/bambu-studio"
	doicon -s 192 "${S}"/squashfs-root/BambuStudio.png
	domenu "${FILESDIR}/${MY_PN}.desktop"
	dobin "${FILESDIR}/bambu-studio"
}
