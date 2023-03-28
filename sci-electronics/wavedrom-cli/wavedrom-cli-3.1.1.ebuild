# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"

DESCRIPTION="WaveDrom command-line interface"
HOMEPAGE="
	https://wavedrom.com
	https://github.com/wavedrom/cli
"

SRC_URI="https://github.com/vowstar/wavedrom-cli/releases/download/v${PV}/${P}.tgz"
S="${WORKDIR}"/package

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

RDEPEND="net-libs/nodejs"
BDEPEND=">=net-libs/nodejs-12[npm]"

QA_PREBUILT="
	usr/lib64/node_modules/wavedrom-cli/node_modules/@resvg/resvg-js-linux-x64-gnu/resvgjs.linux-x64-gnu.node
	usr/lib64/node_modules/wavedrom-cli/node_modules/@resvg/resvg-js-linux-x64-musl/resvgjs.linux-x64-musl.node
"

src_compile() {
	# Skip, nothing to compile here.
	:
}

src_install() {
	local myopts=(
		--audit false
		--color false
		--foreground-scripts
		--global
		--offline
		--omit dev
		--prefix "${ED}"/usr
		--progress false
		--verbose
	)
	# npm info ms "${DISTDIR}/${P}.tgz" || die "npm info failed"
	npm ${myopts[@]} install "${DISTDIR}/${P}.tgz" || die "npm install failed"

	if use elibc_musl; then
		rm -r "${D}"/usr/lib64/node_modules/wavedrom-cli/node_modules/@resvg/resvg-js-linux-x64-gnu || die
	else
		rm -r "${D}"/usr/lib64/node_modules/wavedrom-cli/node_modules/@resvg/resvg-js-linux-x64-musl || die
	fi

	dodoc *.md
}
