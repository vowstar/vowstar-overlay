# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Daemon driving Supermicro IPMI fan zones from CPU and disk temperatures"
HOMEPAGE="https://github.com/vowstar/ipmifand"
SRC_URI="https://github.com/vowstar/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sys-apps/ipmitool
	sys-apps/smartmontools
"

src_prepare() {
	default
	tc-export CC
}

_emake_args() {
	echo \
		PREFIX=/usr \
		BINDIR=/usr/bin \
		SYSCONFDIR=/etc \
		UNITDIR="$(systemd_get_systemunitdir)" \
		VERSION="${PV}"
}

src_compile() {
	emake $(_emake_args)
}

src_install() {
	emake install DESTDIR="${D}" $(_emake_args)
	dodoc README.md
}
