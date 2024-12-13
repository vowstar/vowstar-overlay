# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="A DICOM viewer available as a desktop application or as a web-based application."
HOMEPAGE="https://nroduit.github.io/ https://github.com/nroduit/Weasis"
SRC_URI="amd64? ( https://github.com/nroduit/Weasis/releases/download/v${PV}/${P/-bin-/_}-1_amd64.deb -> ${P}_amd64.deb )"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	>=virtual/jre-1.8
	x11-misc/shared-mime-info
"

S="${WORKDIR}"

src_install() {
	insinto /opt
	doins -r opt/weasis

	fperms a+x /opt/weasis/bin/Weasis
	fperms a+x /opt/weasis/bin/Dicomizer
	fperms a+x /opt/weasis/lib/runtime/lib/jexec
	fperms a+x /opt/weasis/lib/runtime/lib/jspawnhelper

	domenu opt/weasis/lib/weasis-Weasis.desktop
	domenu opt/weasis/lib/weasis-Dicomizer.desktop

	URLWLPATH=("etc/opt/chrome/policies/managed/" "etc/chromium/policies/managed/")
	for p in "${URLWLPATH[@]}"; do
		mkdir -p "${ED}"/${p} || die
		echo '{'$'\n''    "URLWhitelist": ["weasis://*"]'$'\n''}' >"${ED}"/${p}weasis.json || die
	done
}
