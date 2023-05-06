# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/.}"
inherit udev unpacker

DESCRIPTION="The Adept Runtime to communicate with Digilent's devices"
HOMEPAGE="https://digilent.com/shop/software/digilent-adept"
SRC_URI="
	amd64? ( https://digilent.s3.amazonaws.com/Software/Adept2+Runtime/${PV}/${MY_PN}_${PV}-amd64.deb )
	arm64? ( https://digilent.s3.amazonaws.com/Software/Adept2+Runtime/${PV}/${MY_PN}_${PV}-arm64.deb )
	arm? ( https://digilent.s3.amazonaws.com/Software/Adept2+Runtime/${PV}/${MY_PN}_${PV}-armhf.deb )
	x86? ( https://digilent.s3.amazonaws.com/Software/Adept2+Runtime/${PV}/${MY_PN}_${PV}-i386.deb )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RESTRICT="mirror strip test"

RDEPEND="
	dev-libs/libusb
"

DEPEND="${RDEPEND}"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	rm -r "${S}/usr/share/lintian" || die
	mv "${S}/etc/udev" "${T}" || die
	mv "${S}/usr/share/doc" "${T}" || die
	mv "${S}/usr/sbin" "${T}" || die
	gunzip "${T}"/doc/${MY_PN}/*.gz || die
	insinto /
	doins -r "${S}/usr"
	doins -r "${S}/etc"
	udev_dorules "${T}"/udev/rules.d/*.rules
	dosbin "${T}"/sbin/*
	dodoc "${T}"/doc/${MY_PN}/*
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
