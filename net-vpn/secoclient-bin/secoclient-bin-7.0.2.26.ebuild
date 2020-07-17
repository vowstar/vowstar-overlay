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

RDEPEND=""

DEPEND="${RDEPEND}"

BDEPEND=""

src_unpack() {
	mkdir ${S} || die
	cd ${S} || die
	unpack_makeself "${DISTDIR}/${MY_FILE}" "$(grep -a ^lines= "${DISTDIR}/${MY_FILE}" | tr '=' ' ' | awk '{print $2}' | head -n 1)" tail
}

src_install() {
	cd ${S} || die
	rm -rf bak || die
	insinto /opt/${MY_PN}
	dodir /opt/${MY_PN}/certificate
	doins -r ./*
}
