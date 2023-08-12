# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unofficial Microsoft Teams for Linux client"
HOMEPAGE="https://github.com/IsmaelMartinez/teams-for-linux"
SRC_URI="https://github.com/IsmaelMartinez/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/nss
	sys-apps/util-linux
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils

"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	dodir /opt/teams-for-linux
	cp -R "${WORKDIR}/teams-for-linux-${PV}/." "${D}/opt/teams-for-linux/" || die "Install failed!"
	dosym "../../opt/teams-for-linux/teams-for-linux" /usr/bin/teams-for-linux
}
