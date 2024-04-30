# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# From release tag name
MY_PV="v0.0-3644-g6882622d"

DESCRIPTION="SystemVerilog parser, style-linter, and formatter"
HOMEPAGE="
	https://chipsalliance.github.io/verible/
	https://github.com/chipsalliance/verible
"

# Bazel's gentoo package is a disaster to maintain. There is really not enough
# time to maintain the source package, so starting from 0.0.3644, it will be
# switched to a binary package.
REL_URI="https://github.com/chipsalliance/verible/releases/download"
SRC_URI="
	amd64? ( ${REL_URI}/${MY_PV}/verible-${MY_PV}-linux-static-x86_64.tar.gz )
	arm64? ( ${REL_URI}/${MY_PV}/verible-${MY_PV}-linux-static-arm64.tar.gz )
"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"

src_install() {
	dobin "${S}"/bin/*
}
