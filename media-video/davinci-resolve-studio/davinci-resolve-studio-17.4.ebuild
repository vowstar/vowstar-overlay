# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MAJOR_VER="$(ver_cut 1-2)"
if [[ "${PN}" == "davinci-resolve-studio" ]] ; then
	BASE_NAME="DaVinci_Resolve_Studio_${MAJOR_VER}_Linux"
	#CONFLICT_PKG="media-video/davinci-resolve"
else
	BASE_NAME="DaVinci_Resolve_${MAJOR_VER}_Linux"
	CONFLICT_PKG="media-video/davinci-resolve-studio"
fi
ARC_NAME="${BASE_NAME}.zip"

inherit xdg

DESCRIPTION="Professional A/V post-production software suite"
HOMEPAGE="
	https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion
"
SRC_URI="DaVinci_Resolve_Studio_17.4_Linux.zip"

LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64"
SLOT="0"
IUSE="doc udev"

RESTRICT="strip mirror bindist fetch"

RDEPEND="
	virtual/glu
	x11-libs/gtk+:=
	${CONFLICT_PKG}
"

DEPEND="
	app-arch/libarchive
	dev-libs/ocl-icd
	dev-libs/openssl-compat
	dev-qt/qtcore:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5
	media-libs/gstreamer
	media-libs/libpng
	sys-fs/fuse
	udev? ( virtual/udev )
	virtual/opencl
	x11-misc/xdg-user-dirs
	${RDEPEND}
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - ${ARC_NAME}"
	einfo "from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_install() {
	local PKG_NAME=resolve
	local APP_NAME=com.blackmagicdesign.resolve
	# Creating missing folders
	mkdir -p -m 0775 "${D}/opt/${PKG_NAME}/"{configs,DolbyVision,easyDCP,Fairlight,GPUCache,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT} || die
	mkdir -p "${D}/usr/share/"{applications,desktop-directories,icons/hicolor,mime/packages} || die
	mkdir -p "${D}/usr/lib/udev/rules.d" || die
	mkdir -p "${D}/etc/xdg/menus" || die
	chmod u+x ./"${BASE_NAME}".run || die
	./"${BASE_NAME}".run -i -y -n -a -C "${D}"/opt/resolve || die

	find "${D}"/usr/share "${D}"/etc -type f -name *.desktop -o -name *.directory -o -name *.menu | xargs -I {} sed -i "s|RESOLVE_INSTALL_LOCATION|/opt/${PKG_NAME}|g" {} || die

	# This will help adding the app to favorites and prevent glitches on many desktops.
	echo "StartupWMClass=resolve" >> "${D}/usr/share/applications/${APP_NAME}.desktop" || die

	# Setting the right permissions"
	chown -R root:root "${D}/opt/${PKG_NAME}/"{configs,DolbyVision,easyDCP,Fairlight,logs,Media,'Resolve Disk Database',.crashreport,.license,.LUT} || die

	# Install launchers and configs
	pushd "${D}/opt/${PKG_NAME}/" || die

	dodir "/opt/${PKG_NAME}/configs"
	insinto "/opt/${PKG_NAME}/configs"
	insopts -m0666
	doins share/default-config.dat
	doins share/log-conf.xml
	dodir "/opt/${PKG_NAME}/DolbyVision"
	insinto "/opt/${PKG_NAME}/DolbyVision"
	insopts -m0666
	doins share/default_cm_config.bin
	dodir /usr/share/applications
	insinto /usr/share/applications
	insopts -m0644
	doins share/DaVinciResolve.desktop
	doins share/DaVinciControlPanelsSetup.desktop
	doins share/DaVinciResolveInstaller.desktop
	doins share/DaVinciResolveCaptureLogs.desktop
	doins share/blackmagicraw-player.desktop
	doins share/blackmagicraw-speedtest.desktop
	dodir /usr/share/desktop-directories
	insinto /usr/share/desktop-directories
	insopts -m0644
	doins share/DaVinciResolve.directory
	dodir /etc/xdg/menus
	insinto /etc/xdg/menus
	insopts -m0644
	doins share/DaVinciResolve.menu
	dodir /usr/share/icons/hicolor/64x64/apps
	insinto /usr/share/icons/hicolor/64x64/apps
	insopts -m0644
	doins graphics/DV_Resolve.png
	doins graphics/DV_ResolveProj.png
	dodir /usr/share/mime/packages
	insinto /usr/share/mime/packages
	insopts -m0644
	doins share/resolve.xml

	if use udev ; then
		# Creating and installing udev rules
		echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"' > "${D}/"$(get_udevdir)"/75-davincipanel.rules" || die
		echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1edb", MODE="0666"' > "${D}/"$(get_udevdir)"/75-sdx.rules" || die
	fi

	popd || die

	if use doc ; then
		dodoc *.pdf
	fi
}