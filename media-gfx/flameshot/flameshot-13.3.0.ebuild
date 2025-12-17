# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"

# Qt-Color-Widgets commit used by flameshot
QCW_COMMIT="352bc8f99bf2174d5724ee70623427aa31ddc26a"

SRC_URI="
	https://github.com/flameshot-org/flameshot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.com/mattbas/Qt-Color-Widgets/-/archive/${QCW_COMMIT}/Qt-Color-Widgets-${QCW_COMMIT}.tar.bz2
"

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

src_prepare() {
	# Use pre-downloaded Qt-Color-Widgets instead of FetchContent
	mkdir -p "${S}/external" || die
	mv "${WORKDIR}/Qt-Color-Widgets-${QCW_COMMIT}" "${S}/external/Qt-Color-Widgets" || die
	cmake_src_prepare
}

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
