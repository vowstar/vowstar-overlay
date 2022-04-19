# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PV="v0.0-2135-gb534c1fe"

inherit bazel

DESCRIPTION="SystemVerilog parser, style-linter, and formatter"
HOMEPAGE="
	https://chipsalliance.github.io/verible
	https://github.com/chipsalliance/verible
"

bazel_external_uris="

"

SRC_URI="
	https://github.com/chipsalliance/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	${bazel_external_uris}
"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl
	sys-libs/zlib
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-devel/m4
"

src_unpack() {
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
}

src_compile() {
	ebazel build -c opt --//bazel:use_local_flex_bison //...
	ebazel shutdown
}

src_test() {
	ebazel test -c opt --//bazel:use_local_flex_bison //...
}

src_install() {
	ebazel run -c opt --//bazel:use_local_flex_bison //:install -- "${D}/usr/bin"
	ebazel shutdown
}
