# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools libtool

DESCRIPTION="Double-Array Trie Library"
HOMEPAGE="https://github.com/tlwg/libdatrie"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tlwg/${PN}.git"
else
	SRC_URI="https://github.com/tlwg/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="dev-vcs/git"

src_prepare() {
	default
	# Fixed version if in non git project
	echo ${PV} > VERSION
	# From upstreams autogen.sh, to make it utilize the autotools eclass
	# Here translate the autogen.sh, equivalent to the following code
	# > sh autogen.sh
	eautoheader
	elibtoolize --force
	eaclocal
	eautomake --add-missing
	# Not allow git-version-gen does refresh
	eautoconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-html-docdir="${EPREFIX}/usr/share/doc/${PF}/html"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
