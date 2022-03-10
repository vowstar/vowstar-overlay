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
	mkdir -p "${WORKDIR}"/usr/share/icons/hicolor/scalable/apps || die
	mv "${WORKDIR}"/opt/apps/${MY_PGK_NAME} "${WORKDIR}"/opt/${MY_PGK_NAME} || die
	mv "${WORKDIR}"/opt/${MY_PGK_NAME}/entries/icons/hicolor/scalable/apps/*.svg "${WORKDIR}"/usr/share/icons/hicolor/scalable/apps || die
	sed -i '5c Exec=zw3d %F' "${WORKDIR}/usr/share/applications/${MY_PGK_NAME}.desktop" || die
	sed -i '6c Icon=ZW3Dprofessional' "${WORKDIR}/usr/share/applications/${MY_PGK_NAME}.desktop" || die
	mkdir -p "${WORKDIR}"/usr/bin/ || die

	cat >> "${WORKDIR}"/opt/${MY_PGK_NAME}/zw3d <<- EOF || die
#!/bin/sh
MY_PGK_NAME="com.zwsoft.zw3dprofessional"
MY_PKG_HOME="/opt/${MY_PGK_NAME}/files"
cd ${MY_PKG_HOME}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${MY_PKG_HOME}/lib:${MY_PKG_HOME}/lib/xlator:${MY_PKG_HOME}/lib/xlator/InterOp:${MY_PKG_HOME}/libqt:${MY_PKG_HOME}/libqt/plugins/designer:${MY_PKG_HOME}/lib3rd:$LD_LIBRARY_PATH

./zw3d $*
	EOF
	fperms 0755 "${WORKDIR}"/opt/${MY_PGK_NAME}/zw3d
	ln -s /opt/${MY_PGK_NAME}/zw3d "${WORKDIR}"/usr/bin/zw3d || die

	insinto /opt
	doins -r opt/${MY_PGK_NAME}
	insinto /usr
	doins -r usr/*
}
