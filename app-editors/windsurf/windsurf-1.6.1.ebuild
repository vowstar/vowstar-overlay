# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg shell-completion

DESCRIPTION="AI-powered code editor maintaining flow state with instant assistance."
HOMEPAGE="https://codeium.com"

SRC_URI="https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt/pool/main/w/windsurf/Windsurf-linux-x64-${PV}.deb"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror strip"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/gnupg
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-process/lsof
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/shared-mime-info
	x11-misc/xdg-utils
"

DEPEND="${RDEPEND}"

QA_PREBUILT="
	opt/windsurf/chrome-sandbox
	opt/windsurf/chrome_crashpad_handler
	opt/windsurf/windsurf
	opt/windsurf/libEGL.so
	opt/windsurf/libGLESv2.so
	opt/windsurf/libffmpeg.so
	opt/windsurf/libvk_swiftshader.so
	opt/windsurf/libvulkan.so.1
	opt/windsurf/*.so
	opt/windsurf/*.so.*
"

src_install() {
	# Install application files
	insinto /opt/windsurf
	doins -r "${S}/usr/share/windsurf/"*

	# Fix chrome-sandbox permissions
	fperms 4755 /opt/windsurf/chrome-sandbox

	# Make executables executable
	local f
	for f in ${QA_PREBUILT}; do
		[[ -f "${D}/${f}" ]] && fperms +x "/${f}"
	done

	# Install launcher script
	dosym ../../opt/windsurf/windsurf /usr/bin/windsurf

	# Install desktop files
	domenu "${S}/usr/share/applications/windsurf.desktop"
	domenu "${S}/usr/share/applications/windsurf-url-handler.desktop"

	# Install icon
	doicon "${S}/usr/share/pixmaps/windsurf.png"

	# Install metainfo
	insinto /usr/share/metainfo
	doins "${S}/usr/share/appdata/windsurf.appdata.xml"

	# Install MIME type definitions
	insinto /usr/share/mime/packages
	doins "${S}/usr/share/mime/packages/windsurf-workspace.xml"

	# Install completions
	newbashcomp "${S}/usr/share/bash-completion/completions/windsurf" windsurf
	newzshcomp "${S}/usr/share/zsh/vendor-completions/_windsurf" _windsurf
}
