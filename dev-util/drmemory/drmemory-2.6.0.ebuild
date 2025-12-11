# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Memory debugging tool for Linux and Windows"
HOMEPAGE="https://drmemory.org/ https://github.com/DynamoRIO/drmemory"

# DynamoRIO submodule commit for release_2.6.0
DRIO_COMMIT="bbd4ffadd03a7630b6143035c369bf7714357eeb"
# Googletest submodule commit
GTEST_COMMIT="12ddfca458945b8fcffa7ed416076ed55bf669b1"
# DynamoRIO's submodules (libipt and zlib)
LIBIPT_COMMIT="c848a85c3104e2f5780741f85de5c9e65476ece2"
ZLIB_COMMIT="21767c654d31d2dccdde4330529775c6c5fd5389"

SRC_URI="
	https://github.com/DynamoRIO/${PN}/archive/release_${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/DynamoRIO/dynamorio/archive/${DRIO_COMMIT}.tar.gz
		-> dynamorio-${DRIO_COMMIT:0:7}.tar.gz
	https://github.com/DynamoRIO/googletest/archive/${GTEST_COMMIT}.tar.gz
		-> googletest-${GTEST_COMMIT:0:7}.tar.gz
	https://github.com/intel/libipt/archive/${LIBIPT_COMMIT}.tar.gz
		-> libipt-${LIBIPT_COMMIT:0:7}.tar.gz
	https://github.com/madler/zlib/archive/${ZLIB_COMMIT}.tar.gz
		-> zlib-${ZLIB_COMMIT:0:7}.tar.gz
"

S="${WORKDIR}/${PN}-release_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/libunwind:=
	dev-lang/perl
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.0-cmake-cmp0043.patch"
	"${FILESDIR}/${PN}-2.6.0-gcc-asm-flags.patch"
	"${FILESDIR}/${PN}-2.6.0-gcc15.patch"
	"${FILESDIR}/${PN}-2.6.0-stdbool.patch"
	"${FILESDIR}/${PN}-2.6.0-cxx20-destructor.patch"
	"${FILESDIR}/${PN}-2.6.0-strcasestr.patch"
	"${FILESDIR}/${PN}-2.6.0-uninitialized.patch"
	"${FILESDIR}/${PN}-2.6.0-enum-mismatch.patch"
	"${FILESDIR}/${PN}-2.6.0-options-bool.patch"
	"${FILESDIR}/${PN}-2.6.0-memlayout-bool.patch"
)

QA_FLAGS_IGNORED="
	opt/drmemory/.*
"
QA_PREBUILT="
	opt/drmemory/.*
"

src_prepare() {
	# Setup bundled DynamoRIO
	rmdir "${S}/dynamorio" || die
	mv "${WORKDIR}/dynamorio-${DRIO_COMMIT}" "${S}/dynamorio" || die

	# Setup DynamoRIO's bundled libipt
	rmdir "${S}/dynamorio/third_party/libipt" || die
	mv "${WORKDIR}/libipt-${LIBIPT_COMMIT}" "${S}/dynamorio/third_party/libipt" || die

	# Setup DynamoRIO's bundled zlib
	rmdir "${S}/dynamorio/third_party/zlib" || die
	mv "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/dynamorio/third_party/zlib" || die

	# Setup bundled googletest
	rmdir "${S}/third_party/googletest" || die
	mv "${WORKDIR}/googletest-${GTEST_COMMIT}" "${S}/third_party/googletest" || die

	# Fix cmake install commands to respect DESTDIR
	# The file(WRITE/MAKE_DIRECTORY/APPEND) and configure_file() commands
	# do not automatically respect the DESTDIR environment variable
	sed -i \
		-e 's|"\\${CMAKE_INSTALL_PREFIX}/|"\\$ENV{DESTDIR}\\${CMAKE_INSTALL_PREFIX}/|g' \
		"${S}/CMakeLists.txt" "${S}/docs/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
	# DynamoRIO needs specific compiler flags
	filter-flags -fstack-protector-strong -fstack-clash-protection
	append-flags -fno-stack-protector

	# Avoid AVX-512 for portability
	append-flags -mno-avx512f

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/${PN}"
		-DBUILD_TOOL_TESTS=$(usex test ON OFF)
	)

	# Disable doxygen search when doc USE is disabled
	# drmemory unconditionally runs find_package(Doxygen) and builds docs if found
	if ! use doc; then
		mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Remove incorrectly installed DynamoRIO build artifacts
	# These are cmake install targets that don't properly respect DESTDIR
	rm -rf "${ED}/var" || die

	# Create symlinks in /usr/bin for main tools
	dodir /usr/bin
	local tool
	for tool in drmemory drltrace drstrace symquery; do
		if [[ -x "${ED}/opt/${PN}/bin64/${tool}" ]]; then
			dosym "../../opt/${PN}/bin64/${tool}" "/usr/bin/${tool}"
		fi
	done

	dodoc README.md
}
