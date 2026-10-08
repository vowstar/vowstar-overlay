# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Quick System on Chip Studio for SoC design and Verilog code generation"
HOMEPAGE="https://github.com/vowstar/qsoc"

SRC_URI="https://github.com/vowstar/qsoc/releases/download/v${PV}/${P}.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-cpp/yaml-cpp:=
	dev-libs/libfmt:=
	>=dev-qt/qtbase-6.5:6[gui,network,widgets]
	>=dev-qt/qtsvg-6.5:6
	>=sci-electronics/slang-11
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	>=dev-qt/qt5compat-6.5:6[gui]
"
BDEPEND="
	>=dev-qt/qttools-6.5:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_SOURCE_DIR_FMT="${S}/external/fmt"
		-DBUILD_SHARED_LIBS=OFF
		-DANTLR_BUILD_SHARED=OFF
		-DLIBSSH2_DISABLE_INSTALL=ON
		-DQSCHEMATIC_BUILD_SHARED=OFF
		-DSLANG_USE_MIMALLOC=OFF
		-DSLANG_USE_CPPTRACE=OFF
		-DSLANG_INCLUDE_TESTS=OFF
		-DENABLE_CLANG_TIDY=OFF
		-DENABLE_DOXYGEN=OFF
		-DENABLE_SPDX_HEADERS=OFF
		-DENABLE_UNIT_TEST=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Bundled third-party projects add their own install rules.
	rm -rf \
		"${ED}"/usr/include \
		"${ED}"/usr/$(get_libdir)/cmake \
		"${ED}"/usr/$(get_libdir)/pkgconfig \
		"${ED}"/usr/$(get_libdir)/lib*.a \
		"${ED}"/usr/$(get_libdir)/lib*.so \
		"${ED}"/usr/$(get_libdir)/lib*.so.* \
		"${ED}"/usr/share/cmake \
		"${ED}"/usr/share/doc
}
