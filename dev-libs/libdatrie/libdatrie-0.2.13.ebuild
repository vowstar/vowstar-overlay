# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool

DESCRIPTION="Double-Array Trie Library"
HOMEPAGE="https://github.com/tlwg/libdatrie"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tlwg/${PN}.git"
else
	SRC_URI="https://github.com/tlwg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="dev-vcs/git"

src_prepare() {
	default
	# From upstreams autoconf.sh, to make it utilize the autotools eclass
	# Here translate the autoconf.sh, equivalent to the following code
	# > sh autoconf.sh
	eautoheader
	elibtoolize --force
	eaclocal
	eautomake --add-missing
	# Use -f so git-version-gen does refresh
	eautoconf -f
}