# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Policy-driven snapshot management and replication tools."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cron systemd"

REQUIRED_USE="cron? ( !systemd )"

RDEPEND="
	>=dev-lang/perl-5.30
	app-arch/gzip
	app-arch/lz4
	app-arch/lzop
	app-arch/zstd
	cron? ( virtual/cron )
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-apps/pv
	sys-block/mbuffer
	virtual/ssh
"
DEPEND="${RDEPEND}"

DOCS="CHANGELIST LICENSE README.md"

src_prepare() {
	default
	sed -i 's|/usr/sbin|/usr/bin|g' \
		"packages/debian/sanoid.timer" \
		"packages/debian/sanoid.service" \
		"packages/debian/sanoid-prune.service" || die
}

src_install() {
	# Documents
	einstalldocs
	# Configs
	insinto /etc/sanoid
	doins sanoid.defaults.conf
	doins sanoid.conf
	# Binaries
	dobin sanoid syncoid findoid sleepymutex
	# Cron
	if use cron; then
		insinto /etc/cron.d
		echo "* * * * * root TZ=UTC /usr/bin/sanoid --cron" > "${PN}.cron" || die
		newins "${PN}.cron" "${PN}"
	fi
	# Systemd
	if use systemd; then
		systemd_dounit "packages/debian/sanoid.service"
		systemd_dounit "packages/debian/sanoid.timer"
		systemd_dounit "packages/debian/sanoid-prune.service"
	fi
}

pkg_postinst() {
	elog "Edit the /etc/sanoid/sanoid.conf file to configure sanoid."
	if use cron; then
		elog "/etc/cron.d/sanoid executes \`sanoid --cron\` every minute."
	fi
	if use systemd; then
		elog "systemd units are installed. Enable them with:"
		elog "systemctl enable sanoid.service"
		elog "systemctl enable sanoid-prune.service"
	fi
}
