# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="jd-gui"
MY_P="jd-gui-${PV}"

inherit desktop rpm xdg

DESCRIPTION="A standalone graphical utility that displays Java source codes of .class file"
HOMEPAGE="http://jd.benow.ca/"
SRC_URI="https://github.com/java-decompiler/jd-gui/releases/download/v${PV}/${MY_P}.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/opt/jd-gui"

src_install() {
	insinto /opt/"${MY_PN}"
	dodir /opt/"${MY_PN}"
	mv "${MY_P}"*.jar "${MY_P}.jar" || die
	doins "${MY_P}.jar"

	echo -e "#!/bin/sh\njava -jar /opt/${MY_PN}/${MY_P}.jar >/dev/null 2>&1 &\n" > "${MY_PN}"
	dobin "${MY_PN}"

	mv jd_*.png "${MY_PN}.png" || die
	doicon -s 128 "${MY_PN}.png"

	sed -i "s|Exec=.*$|Exec=java -jar /opt/${MY_PN}/${MY_P}.jar|g" jd-gui.desktop
	sed -i "s|Icon=.*$|Icon=${MY_PN}|g" jd-gui.desktop
	domenu jd-gui.desktop
}
