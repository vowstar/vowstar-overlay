# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="secoclient"

if [[ "${ARCH}" == "amd64" ]]; then
	MY_BIT="64"
elif [[ "${ARCH}" = "x86" ]]; then
	MY_BIT="32"
else
	die "Unsuppoted ARCH ${ARCH}"
fi
MY_FILE="${MY_PN}-linux-${MY_BIT}-${PV}.run"

inherit unpacker xdg

DESCRIPTION="Huawei VPN client software to remotely access enterprise network"
HOMEPAGE="https://support.huawei.com/enterprise/en/doc/EDOC1000141431"

SRC_URI="https://github.com/h2o8/${MY_PN}/releases/download/${PV}/${MY_FILE}"

LICENSE="all-rights-reserved"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

RESTRICT="strip test"

RDEPEND="
	dev-libs/icu
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"

DEPEND="${RDEPEND}"

BDEPEND="dev-util/patchelf"

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack_makeself "${DISTDIR}/${MY_FILE}" "$(grep -a ^lines= "${DISTDIR}/${MY_FILE}" | tr '=' ' ' | awk '{print $2}' | head -n 1)" tail
}

src_prepare() {
	default
	# Remove the libraries and use the system libs instead
	rm -rf "${S}/lib" || die
	rm -rf "${S}/bak" || die
	rm -rf "${S}/plugins" || die
	rm -rf "${S}/qt.conf" || die
	rm -rf "${S}/*.sh" || die
	# Set RPATH for fix relative DT_RPATH security problem
	patchelf --set-rpath '$ORIGIN' "${S}/SecoClient" || die
}

src_install() {
	insinto "/opt/${MY_PN}"
	dodir "/opt/${MY_PN}/certificate"
	doins -r ./*
}
