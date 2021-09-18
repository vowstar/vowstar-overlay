# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GIT_PN="UxPlay"

inherit cmake

DESCRIPTION="AirPlay Unix mirroring server"
HOMEPAGE="https://github.com/FDH2/UxPlay"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/FDH2/${GIT_PN}.git"
	inherit git-r3
else
	EGIT_COMMIT="0daf36201dd2de1305f3254c2a7424a9dd67309b"
	SRC_URI="https://github.com/FDH2/${GIT_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${GIT_PN}-${EGIT_COMMIT}"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	dev-libs/openssl
	media-libs/gstreamer
	media-libs/gst-plugins-bad
	media-plugins/gst-plugins-libav
	net-dns/avahi[mdnsresponder-compat]
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-fix-installation.patch"
	"${FILESDIR}/${P}-fix-screen-sharing.patch"
	"${FILESDIR}/${P}-use-machine-hostname.patch"
)
