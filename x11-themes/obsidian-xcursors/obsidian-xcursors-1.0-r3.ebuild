# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-any-r1

MY_PN="Obsidian"

DESCRIPTION="A shiny and clean xcursor theme"
HOMEPAGE="https://store.kde.org/p/999984/"
SRC_URI="mirror://gentoo/73135-${MY_PN}.tar.bz2"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="x11-libs/libXcursor"

BDEPEND="
	$(python_gen_any_dep 'dev-python/pillow[${PYTHON_USEDEP}]')
	x11-apps/xcursorgen
"

python_check_deps() {
	python_has_version "dev-python/pillow[${PYTHON_USEDEP}]"
}

src_compile() {
	"${EPYTHON}" "${FILESDIR}"/build-cursors.py Source "${WORKDIR}"/theme || die
}

src_install() {
	insinto /usr/share/icons/${MY_PN}
	# index.theme belongs to x11-themes/obsidian-icon-theme
	doins -r "${WORKDIR}"/theme/cursors
}
