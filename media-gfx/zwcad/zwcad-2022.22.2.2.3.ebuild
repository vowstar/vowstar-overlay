# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PGK_NAME="com.zwsoft.zwcad2022"
inherit desktop unpacker xdg

DESCRIPTION="CAD software for 2D drawing, reviewing and printing work"
HOMEPAGE="https://www.zwsoft.cn/product/zwcad/linux"
SRC_URI="https://download.zwcad.com/zwcad/cad_linux/2022/SP2/signed_com.zwsoft.zwcad2022_22.2.2.3_amd64.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="strip mirror bindist"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/atk
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/libxml2
	dev-qt/qtsvg:5
	dev-qt/qtwayland:5
	media-gfx/imagemagick
	media-libs/libglvnd
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libxkbcommon
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/pango
"

DEPEND="${RDEPEND}"

BDEPEND="dev-util/patchelf"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	# Install scalable icons
	doicon -s scalable "${S}"/opt/apps/${MY_PGK_NAME}/files/Icons/ZWCAD.svg

	# Set RPATH for preserve-libs handling
	pushd "${S}"/opt/apps/${MY_PGK_NAME}/files || die
	local x
	for x in $(find) ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		local RPATH_ROOT="/opt/apps/${MY_PGK_NAME}/files"
		local RPATH_S="${RPATH_ROOT}/:${RPATH_ROOT}/lib/:${RPATH_ROOT}/plugins/:${RPATH_ROOT}/zh-CN/"
		patchelf --set-rpath "${RPATH_S}" "${x}" || \
			die "patchelf failed on ${x}"
	done
	popd || die

	# Fix desktop files
	sed -E -i 's/^Exec=.*$/Exec=zwcad %F/g' "${S}/opt/apps/${MY_PGK_NAME}/entries/applications/com.zwsoft.zwcad.desktop" || die
	sed -E -i 's/^Icon=.*$/Icon=ZWCAD/g' "${S}/opt/apps/${MY_PGK_NAME}/entries/applications/com.zwsoft.zwcad.desktop" || die
	sed -E -i 's/Application;//g' "${S}/opt/apps/${MY_PGK_NAME}/entries/applications/com.zwsoft.zwcad.desktop" || die
	domenu "${S}/opt/apps/${MY_PGK_NAME}/entries/applications/com.zwsoft.zwcad.desktop"

	# Add zw3d command
	mkdir -p "${S}"/usr/bin/ || die

	cat >> "${S}"/opt/apps/${MY_PGK_NAME}/zwcad <<- EOF || die
#!/bin/sh
sh /opt/apps/${MY_PGK_NAME}/files/ZWCADRUN.sh \$*
	EOF

	ln -s /opt/apps/${MY_PGK_NAME}/zwcad "${S}"/usr/bin/zwcad || die

	# Install package and fix permissions
	insinto /opt/apps/
	doins -r opt/apps/${MY_PGK_NAME}
	insinto /usr
	doins -r usr/*

	fperms 0755 /opt/apps/${MY_PGK_NAME}/zwcad

	pushd "${S}" || die
	for x in $(find "opt/apps/${MY_PGK_NAME}") ; do
		# Fix shell script permissions
		[[ "${x: -3}" == ".sh" ]] && fperms 0755 "/${x}"
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] && fperms 0755 "/${x}"
	done
	popd || die
}
