# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Client for PlayStation 4 and PlayStation 5 Remote Play"
HOMEPAGE="https://git.sr.ht/~thestr4ng3r/chiaki"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://git.sr.ht/~thestr4ng3r/${PN}"
	inherit git-r3
else
	SRC_URI="https://git.sr.ht/~thestr4ng3r/${PN}/refs/download/v${PV}/${PN}-v${PV}-src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="debug"

RDEPEND="
	dev-libs/jerasure
	dev-libs/openssl
	dev-qt/qtmultimedia
	dev-qt/qtsvg
	media-libs/libsdl2
	media-libs/opus
	media-video/ffmpeg
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-libs/protobuf
	dev-python/protobuf-python
	virtual/pkgconfig
"

src_configure() {
	local CMAKE_CONF="
		!debug? ( -DCMAKE_BUILD_TYPE=Release )
		debug? ( -DCMAKE_BUILD_TYPE=Debug )
	"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DNVML_INCLUDE_DIRS="${S}/include"
		-DCHIAKI_USE_SYSTEM_JERASURE
		${CMAKE_CONF}
	)

	cmake_src_configure
}
