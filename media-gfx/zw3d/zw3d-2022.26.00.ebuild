# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PGK_NAME="com.zwsoft.zw3dprofessional"
inherit unpacker xdg

DESCRIPTION="CAD/CAM software for 3D design and processing"
HOMEPAGE="https://www.zwsoft.cn/product/zw3d/linux"
SRC_URI="https://download.zwcad.com/zw3d/3d_linux/2022/ZW3D-2022-Professional-V1.0_amd64.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="strip mirror bindist"

RDEPEND="
	media-libs/jbigkit
"

DEPEND="${RDEPEND}"

BDEPEND="dev-util/patchelf"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	mkdir -p "${S}"/usr/share/icons/hicolor/scalable/apps || die
	mv "${S}"/opt/apps/${MY_PGK_NAME} "${S}"/opt/${MY_PGK_NAME} || die
	mv "${S}"/opt/${MY_PGK_NAME}/entries/icons/hicolor/scalable/apps/*.svg "${S}"/usr/share/icons/hicolor/scalable/apps || die
	sed -E -i 's/^Exec=.*$/Exec=zw3d %F/g' "${S}/usr/share/applications/${MY_PGK_NAME}.desktop" || die
	sed -E -i 's/^Icon=.*$/ZW3Dprofessional/g' "${S}/usr/share/applications/${MY_PGK_NAME}.desktop" || die
	mkdir -p "${S}"/usr/bin/ || die

	cat >> "${S}"/opt/${MY_PGK_NAME}/zw3d <<- EOF || die
#!/bin/sh
sh /opt/${MY_PGK_NAME}/files/zw3drun.sh \$*
	EOF
	
	ln -s /opt/${MY_PGK_NAME}/zw3d "${S}"/usr/bin/zw3d || die

	insinto /opt
	doins -r opt/${MY_PGK_NAME}
	insinto /usr
	doins -r usr/*
	fperms 0755 /opt/${MY_PGK_NAME}/zw3d
}
