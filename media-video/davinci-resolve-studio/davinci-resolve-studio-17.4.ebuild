# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MAJOR_VER="$(ver_cut 1-2)"
if [[ "${PN}" == "davinci-resolve-studio" ]] ; then
	BASE_NAME="DaVinci_Resolve_Studio_${MAJOR_VER}_Linux"
	CONFLICT_PKG="!!media-video/davinci-resolve"
else
	BASE_NAME="DaVinci_Resolve_${MAJOR_VER}_Linux"
	CONFLICT_PKG="!!media-video/davinci-resolve-studio"
fi
ARC_NAME="${BASE_NAME}.zip"

inherit udev xdg

DESCRIPTION="Professional A/V post-production software suite"
HOMEPAGE="
	https://www.blackmagicdesign.com/support/family/davinci-resolve-and-fusion
"
SRC_URI="${ARC_NAME}"

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

BDEPEND="dev-util/patchelf"

S="${WORKDIR}"

QA_PREBUILT="*"

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

	# xorriso -osirrox on -indev "${BASE_NAME}".run -extract / "${BASE_NAME}" || die
	chmod u+x ./"${BASE_NAME}".run || die
	./"${BASE_NAME}".run --appimage-extract || die

	pushd squashfs-root/share/panels || die
	tar -zxvf dvpanel-framework-linux-x86_64.tgz || die
	mv *.so "${S}/squashfs-root/libs" || die
	mv lib/* "${S}/squashfs-root/libs" || die
	popd || die

	# Use portage manage packages so remove installers
	rm -rf "${S}"/squashfs-root/installer "${S}"/squashfs-root/installer* "${S}"/squashfs-root/AppRun "${S}"/squashfs-root/AppRun* || die

	# Fix permission to all files
	chmod 0644 -R "${S}/squashfs-root" || die
	find "${S}/squashfs-root" -type d -exec chmod 0755 "{}" \; || die

	while IFS= read -r -d '' i; do
		chmod 0755 "${i}" || die
	done < <(find "${S}/squashfs-root" -type d -print0)

	while IFS= read -r -d '' i; do
		[[ -f "${i}" && $(od -t x1 -N 4 "${i}") == *"7f 45 4c 46"* ]] || continue
		chmod 0755 "${i}" || die
	done < <(find "${S}/squashfs-root" -type f -print0)

	while IFS= read -r -d '' i; do
		[[ -f "${i}" && $(od -t x1 -N 4 "${i}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath \
'/opt/'"${PKG_NAME}"'/libs:'\
'/opt/'"${PKG_NAME}"'/libs/plugins/sqldrivers:'\
'/opt/'"${PKG_NAME}"'/libs/plugins/xcbglintegrations:'\
'/opt/'"${PKG_NAME}"'/libs/plugins/imageformats:'\
'/opt/'"${PKG_NAME}"'/libs/plugins/platforms:'\
'/opt/'"${PKG_NAME}"'/libs/Fusion:'\
'/opt/'"${PKG_NAME}"'/plugins:'\
'/opt/'"${PKG_NAME}"'/bin:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/BlackmagicRawAPI:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/platforms:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/imageformats:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/mediaservice:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/audio:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/xcbglintegrations:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWSpeedTest/plugins/bearer:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/BlackmagicRawAPI:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/mediaservice:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/imageformats:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/audio:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/platforms:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/xcbglintegrations:'\
'/opt/'"${PKG_NAME}"'/BlackmagicRAWPlayer/plugins/bearer:'\
'/opt/'"${PKG_NAME}"'/Onboarding/plugins/xcbglintegrations:'\
'/opt/'"${PKG_NAME}"'/Onboarding/plugins/qtwebengine:'\
'/opt/'"${PKG_NAME}"'/Onboarding/plugins/platforms:'\
'/opt/'"${PKG_NAME}"'/Onboarding/plugins/imageformats:'\
'/opt/'"${PKG_NAME}"'/DaVinci Control Panels Setup/plugins/platforms:'\
'/opt/'"${PKG_NAME}"'/DaVinci Control Panels Setup/plugins/imageformats:'\
'/opt/'"${PKG_NAME}"'/DaVinci Control Panels Setup/plugins/bearer:'\
'/opt/'"${PKG_NAME}"'/DaVinci Control Panels Setup/AdminUtility/PlugIns/DaVinciKeyboards:'\
'/opt/'"${PKG_NAME}"'/DaVinci Control Panels Setup/AdminUtility/PlugIns/DaVinciPanels:'\
'$ORIGIN' "${i}" || \
		die "patchelf failed on ${i}"
	done < <(find "${S}/squashfs-root" -type f -size -32M -print0)

	while IFS= read -r -d '' i; do
		sed -i "s|RESOLVE_INSTALL_LOCATION|/opt/${PKG_NAME}|g" "${i}" || die
	done < <(find "${S}/squashfs-root" -type f -name *.desktop -o -name *.directory -o -name *.menu -print0)

	# Install the squashfs-root
	cp -rf "${S}"/squashfs-root/* "${D}/opt/${PKG_NAME}" || die

	# Setting the right permissions"
	chown -R root:root "${D}/opt/${PKG_NAME}/"{configs,DolbyVision,easyDCP,Fairlight,logs,Media,'Resolve Disk Database',.crashreport,.license,.LUT} || die
	# Install launchers and configs
	pushd "${D}/opt/${PKG_NAME}/" || die

	ln -s "${D}"/opt/"${PKG_NAME}"/BlackmagicRAWPlayer/BlackmagicRawAPI "${D}"/opt/"${PKG_NAME}"/bin/ || die

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
	# This will help adding the app to favorites and prevent glitches on many desktops.
	echo "StartupWMClass=resolve" >> share/DaVinciResolve.desktop || die
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
		mkdir -p "${D}/$(get_udevdir)" || die
		# Creating and installing udev rules
		echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"' > "${D}/$(get_udevdir)/75-davincipanel.rules" || die
		echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1edb", MODE="0666"' > "${D}/$(get_udevdir)/75-sdx.rules" || die
	fi

	popd || die

	if use doc ; then
		dodoc *.pdf
	fi
}