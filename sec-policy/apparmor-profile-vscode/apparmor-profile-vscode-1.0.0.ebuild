# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A collection of AppArmor profiles for vscode"
HOMEPAGE="https://github.com/vowstar/vowstar-overlay"
S="${WORKDIR}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="sec-policy/apparmor-profiles"
DEPEND="${RDEPEND}"

src_install() {
	insinto /etc/apparmor.d
	doins -r "${FILESDIR}"/opt.vscode
}
