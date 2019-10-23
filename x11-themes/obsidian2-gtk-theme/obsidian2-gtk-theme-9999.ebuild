# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Obsidian Gnome Theme, based upon Adwaita-Maia dark skin"
GIT_PN="theme-obsidian-2"
HOMEPAGE="https://github.com/madmaxms/${GIT_PN}"
LICENSE="GPL-3"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND="
    ${DEPEND}
	>=x11-libs/gtk+-3.22
	x11-themes/gtk-engines-adwaita
"
DOCS=(README.md)

if [[ ${PV} == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/madmaxms/${GIT_PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/madmaxms/${GIT_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

src_install() {
	insinto /usr/share/themes
	doins -r Obsidian*
}
