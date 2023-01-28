# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

if [[ "${PN}" == "davinci-resolve-studio" ]] ; then
	BASE_NAME="DaVinci_Resolve_Studio_${PV}_Linux"
	CONFLICT_PKG="!!media-video/davinci-resolve"
	CHECKREQS_DISK_BUILD=20G
else
	BASE_NAME="DaVinci_Resolve_${PV}_Linux"
	CONFLICT_PKG="!!media-video/davinci-resolve-studio"
	CHECKREQS_DISK_BUILD=15G
fi
ARC_NAME="${BASE_NAME}.zip"

inherit check-reqs desktop udev xdg

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
	app-arch/libarchive
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5
	media-libs/gstreamer
	media-libs/libpng
	|| ( media-libs/tiff:0/0 media-libs/tiff-compat:4 )
	sys-fs/fuse
	sys-libs/libxcrypt
	udev? ( virtual/udev )
	virtual/glu
	virtual/opencl
	x11-libs/gtk+:=
	x11-misc/xdg-user-dirs
	${CONFLICT_PKG}
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	app-arch/unzip
	dev-util/patchelf
"

S="${WORKDIR}"

QA_PREBUILT="*"

pkg_nofetch() {
	einfo "Please download installation file"
	einfo "  - ${ARC_NAME}"
	einfo "from ${HOMEPAGE} and place it in \$\{DISTDIR\}."
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
		elog "chagne ${i}"
	done < <(find . -type f '(' -name "*.desktop" -o -name "*.directory" -o -name "*.directory" -o -name "*.menu" ')' -print0)

	# Install the squashfs-root
	cp -rf "${S}"/squashfs-root/* "${D}/opt/${PKG_NAME}" || die

	# Setting the right permissions"
	chown -R root:root "${D}/opt/${PKG_NAME}/"{configs,DolbyVision,easyDCP,Fairlight,logs,Media,'Resolve Disk Database',.crashreport,.license,.LUT} || die
	# Install launchers and configs
	pushd "${D}/opt/${PKG_NAME}/" || die

	ln -s "${D}"/opt/"${PKG_NAME}"/BlackmagicRAWPlayer/BlackmagicRawAPI "${D}"/opt/"${PKG_NAME}"/bin/ || die

	insinto "/opt/${PKG_NAME}/configs"
	dodir "/opt/${PKG_NAME}/configs"
	insopts -m0666
	doins share/default-config.dat
	doins share/log-conf.xml
	insinto "/opt/${PKG_NAME}/DolbyVision"
	dodir "/opt/${PKG_NAME}/DolbyVision"
	insopts -m0666
	doins share/default_cm_config.bin
	# This will help adding the app to favorites and prevent glitches on many desktops.
	echo "StartupWMClass=resolve" >> share/DaVinciResolve.desktop || die
	domenu share/DaVinciResolve.desktop
	domenu share/DaVinciControlPanelsSetup.desktop
	domenu share/DaVinciResolveInstaller.desktop
	domenu share/DaVinciResolveCaptureLogs.desktop
	domenu share/blackmagicraw-player.desktop
	domenu share/blackmagicraw-speedtest.desktop
	insinto /usr/share/desktop-directories
	dodir /usr/share/desktop-directories
	insopts -m0644
	doins share/DaVinciResolve.directory
	insinto /etc/xdg/menus
	dodir /etc/xdg/menus
	insopts -m0644
	doins share/DaVinciResolve.menu
	local x
	for x in 64; do
		doicon -s ${x} graphics/DV_Resolve.png
		doicon -s ${x} graphics/DV_ResolveProj.png
	done
	doins graphics/DV_Resolve.png
	doins graphics/DV_ResolveProj.png
	insinto /usr/share/mime/packages
	dodir /usr/share/mime/packages
	insopts -m0644
	doins share/resolve.xml

	if use udev ; then
		mkdir -p "${D}/$(get_udevdir)" || die
		# Creating and installing udev rules
		insinto "$(get_udevdir)"/rules.d
		doins share/etc/udev/rules.d/*.rules
	fi

	popd || die

	if use doc ; then
		dodoc *.pdf
	fi
}

pkg_postinst() {
	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
