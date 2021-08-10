# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop multilib unpacker xdg

DESCRIPTION="dingtalk"
HOMEPAGE="https://gov.dingtalk.com"
SRC_URI="com.alibabainc.${PN}_${PV}_amd64.deb"

LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64"
SLOT="0"

RESTRICT="strip mirror bindist fetch"

RDEPEND="
	dev-libs/openssl
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	net-nds/openldap
	sys-libs/glibc
	sys-libs/zlib
"

BDEPEND="dev-util/patchelf"

DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker
	version=$(cat opt/apps/com.alibabainc.dingtalk/files/version)

	# Use system openssl
	rm opt/apps/com.alibabainc.dingtalk/files/${version}/libcrypto* || die
	rm opt/apps/com.alibabainc.dingtalk/files/${version}/libssl* || die
	# Use system QT5
	rm opt/apps/com.alibabainc.dingtalk/files/${version}/libQt5* || die
	# Use system glibc
	rm opt/apps/com.alibabainc.dingtalk/files/${version}/libm.so.6 || die
	# Use system zlib
	rm opt/apps/com.alibabainc.dingtalk/files/${version}/libz* || die
	mkdir -p usr/share/applications || die
	cp opt/apps/com.alibabainc.dingtalk/entries/applications/com.alibabainc.dingtalk.desktop usr/share/applications/ || die
}

pkg_nofetch() {
	einfo "Please follow https://h5.dingtalk.com/circle/healthCheckin.html?corpId=dingdc75e6471f48e6171a5c74e782e240c4&c003e554-f=3edf7be3-a&cbdbhh=qwertyuiop and download"
	einfo "${DISTFILE_BIN}"
	einfo "and place it in your DISTDIR directory."
}