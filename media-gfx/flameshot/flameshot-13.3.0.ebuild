# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 Free-Art-1.3 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="wayland"

# Qt6 version
DEPEND="
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtsvg:6
	sys-apps/dbus
	wayland? ( kde-frameworks/kguiaddons:6 )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
"
RDEPEND="${DEPEND}"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859613
	# https://github.com/flameshot-org/flameshot/issues/3531
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DUSE_KDSINGLEAPPLICATION=ON
		-DUSE_BUNDLED_KDSINGLEAPPLICATION=ON
		-DENABLE_CACHE=OFF
		-DUSE_WAYLAND_CLIPBOARD=$(usex wayland)
		-DDISABLE_UPDATE_CHECKER=ON
	)

	cmake_src_configure
}
