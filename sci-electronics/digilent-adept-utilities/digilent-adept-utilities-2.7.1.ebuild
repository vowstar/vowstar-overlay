# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-/.}"
inherit unpacker

DESCRIPTION="The Adept Utilities to communicate with Digilent's devices"
HOMEPAGE="https://digilent.com/shop/software/digilent-adept"
SRC_URI="
	amd64? ( https://digilent.s3.amazonaws.com/Software/AdeptUtilities/${PV}/${MY_PN}_${PV}-amd64.deb )
	arm64? ( https://digilent.s3.amazonaws.com/Software/AdeptUtilities/${PV}/${MY_PN}_${PV}-arm64.deb )
	arm? ( https://digilent.s3.amazonaws.com/Software/AdeptUtilities/${PV}/${MY_PN}_${PV}-armhf.deb )
	x86? ( https://digilent.s3.amazonaws.com/Software/AdeptUtilities/${PV}/${MY_PN}_${PV}-i386.deb )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RESTRICT="mirror strip test"

RDEPEND="
	dev-libs/libusb
	sci-electronics/digilent-adept-runtime
"

DEPEND="${RDEPEND}"

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	mv "${S}/usr/share/doc" "${T}" || die
	mv "${S}/usr/share/man" "${T}" || die
	mv "${S}/usr/bin" "${T}" || die
	gunzip "${T}"/man/man1/*.gz || die
	gunzip "${T}"/doc/${MY_PN}/*.gz || die
	insinto /
	doins -r "${S}/usr"
	dobin "${T}"/bin/*
	doman "${T}"/man/man1/*.1
	dodoc "${T}"/doc/${MY_PN}/*
}
