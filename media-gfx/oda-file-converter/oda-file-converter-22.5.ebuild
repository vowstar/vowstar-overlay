# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV}.0.0"

inherit desktop unpacker xdg

DESCRIPTION="For converting between different versions of .dwg and .dxf"
HOMEPAGE="https://www.opendesign.com"

SRC_URI="https://download.opendesign.com/guestfiles/Demo/ODAFileConverter_QT5_lnxX64_7.2dll_${PV}.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	dev-qt/qtcore
	x11-themes/hicolor-icon-theme
"

DEPEND="${RDEPEND}"

BDEPEND="dev-util/patchelf"

S="${WORKDIR}"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/ODAFileConverter.*\\.desktop"

src_prepare() {
	patchelf --set-rpath "usr/bin/ODAFileConverter_${MY_PV}" "usr/bin/ODAFileConverter" || die "patchelf failed"
}

src_install() {
	exeinto /usr/bin
	doexe usr/bin/ODAFileConverter
	exeinto /usr/bin/ODAFileConverter_${MY_PV}
	doexe usr/bin/ODAFileConverter_${MY_PV}/*
	domenu usr/share/applications/*.desktop
	doicon -s 16 usr/share/icons/hicolor/16x16/apps/ODAFileConverter.png
	doicon -s 32 usr/share/icons/hicolor/32x32/apps/ODAFileConverter.png
	doicon -s 64 usr/share/icons/hicolor/64x64/apps/ODAFileConverter.png
	doicon -s 128 usr/share/icons/hicolor/128x128/apps/ODAFileConverter.png
}