# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A dynamic instrumentation tool platform"
HOMEPAGE="https://dynamorio.org/ https://github.com/DynamoRIO/dynamorio"

LIBIPT_COMMIT="c848a85c3104e2f5780741f85de5c9e65476ece2"
ZLIB_COMMIT="21767c654d31d2dccdde4330529775c6c5fd5389"
# elfutils submodule commit from release_11.3.0
ELFUTILS_COMMIT="c1058da5a450e33e72b72abb53bc3ffd7f6b361b"

SRC_URI="
	https://github.com/DynamoRIO/${PN}/archive/release_${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/intel/libipt/archive/${LIBIPT_COMMIT}.tar.gz -> libipt-${LIBIPT_COMMIT:0:7}.tar.gz
	https://github.com/madler/zlib/archive/${ZLIB_COMMIT}.tar.gz -> zlib-${ZLIB_COMMIT:0:7}.tar.gz
	https://github.com/libbpf/elfutils-mirror/archive/${ELFUTILS_COMMIT}.tar.gz -> elfutils-${ELFUTILS_COMMIT:0:7}.tar.gz
"

S="${WORKDIR}/${PN}-release_${PV}"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc samples static-libs"

RDEPEND="
	sys-libs/libunwind:=
	app-arch/lz4:=
	app-arch/snappy:=
	dev-lang/perl
	dev-qt/qtbase:6[gui,widgets]
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-11.3.0-cmake-cmp0043.patch"
	"${FILESDIR}/${PN}-11.3.0-asm-syntax-detection.patch"
	"${FILESDIR}/${PN}-11.3.0-gcc-asm-flags.patch"
	"${FILESDIR}/${PN}-11.3.0-gcc15.patch"
)

QA_FLAGS_IGNORED="
	opt/dynamorio/.*
"
QA_PREBUILT="
	opt/dynamorio/.*
"

src_prepare() {
	# Setup bundled libipt
	rmdir "${S}/third_party/libipt" || die
	mv "${WORKDIR}/libipt-${LIBIPT_COMMIT}" "${S}/third_party/libipt" || die

	# Setup bundled zlib
	rmdir "${S}/third_party/zlib" || die
	mv "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/third_party/zlib" || die

	# Setup bundled elfutils
	rmdir "${S}/third_party/elfutils" || die
	mv "${WORKDIR}/elfutils-mirror-${ELFUTILS_COMMIT}" "${S}/third_party/elfutils" || die

	cmake_src_prepare
}

src_configure() {
	# DynamoRIO needs specific compiler flags and doesn't work well with
	# standard Gentoo hardening flags
	filter-flags -fstack-protector-strong -fstack-clash-protection
	append-flags -fno-stack-protector

	# DynamoRIO core explicitly rejects AVX-512 instructions for portability
	# and to avoid frequency scaling issues
	append-flags -mno-avx512f

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/opt/${PN}"
		-DDEBUG=$(usex debug ON OFF)
		-DBUILD_DOCS=$(usex doc ON OFF)
		-DBUILD_SAMPLES=$(usex samples ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Remove static libraries unless requested
	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi

	# Create symlinks in /usr/bin for main tools
	# DynamoRIO uses readlink(/proc/self/exe) to find its base directory,
	# so symlinks work correctly as the kernel resolves to the real path
	dodir /usr/bin
	local tool
	for tool in drrun drconfig drinject drnudgeunix drloader; do
		dosym "../../opt/${PN}/bin64/${tool}" "/usr/bin/${tool}"
	done

	# Install license
	dodoc License.txt
}
