# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/wps-/}"
MY_PN="${PN/wps-/}"

inherit autotools flag-o-matic libtool toolchain-funcs

DESCRIPTION="High-quality and portable font engine"
HOMEPAGE="https://www.freetype.org/"

SRC_URI="
	https://downloads.sourceforge.net/freetype/${MY_P/_/}.tar.xz
	mirror://nongnu/freetype/${MY_P/_/}.tar.xz
"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="X +adobe-cff brotli bzip2 +cleartype-hinting fontforge harfbuzz +png static-libs svg"

RDEPEND="
	>=sys-libs/zlib-1.2.8-r1
	brotli? ( app-arch/brotli )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4 )
	harfbuzz? ( >=media-libs/harfbuzz-1.3.0[truetype] )
	png? ( >=media-libs/libpng-1.2.51:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/0000-WPS-compatiblity.patch"
	"${FILESDIR}/0001-Enable-table-validation-modules.patch"
	"${FILESDIR}/0002-Enable-subpixel-rendering.patch"
	"${FILESDIR}/0003-Enable-long-PCF-family-names.patch"
)

src_prepare() {
	default

	pushd builds/unix &>/dev/null || die
	# eautoheader produces broken ftconfig.in
	AT_NOEAUTOHEADER="yes" AT_M4DIR="." eautoreconf
	popd &>/dev/null || die

	# This is the same as the 01 patch from infinality
	sed '/AUX_MODULES += \(gx\|ot\)valid/s@^# @@' -i modules.cfg || die

	# bug #869803
	rm docs/reference/sitemap.xml.gz || die

	# We need non-/bin/sh to run configure
	if [[ -n ${CONFIG_SHELL} ]] ; then
		sed -i -e "1s:^#![[:space:]]*/bin/sh:#!${CONFIG_SHELL}:" \
			"${S}"/builds/unix/configure || die
	fi

	elibtoolize --patch-only
}

src_configure() {
	append-flags -fno-strict-aliasing

	export GNUMAKE=gmake

	local myeconfargs=(
		--disable-freetype-config
		--enable-shared
		--with-zlib
		$(use_with brotli)
		$(use_with bzip2)
		$(use_with harfbuzz)
		$(use_with png)
		$(use_enable static-libs static)
		--without-librsvg

		# Avoid using libpng-config
		LIBPNG_CFLAGS="$($(tc-getPKG_CONFIG) --cflags libpng)"
		LIBPNG_LDFLAGS="$($(tc-getPKG_CONFIG) --libs libpng)"
	)

	case ${CHOST} in
		mingw*|*-mingw*) ;;
		# Workaround windows mis-detection: bug #654712
		# Have to do it for both ${CHOST}-windres and windres
		*) myeconfargs+=( ac_cv_prog_RC= ac_cv_prog_ac_ct_RC= ) ;;
	esac

	export CC_BUILD="$(tc-getBUILD_CC)"

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	exeinto /opt/kingsoft/wps-office/office6
	doexe ./objs/.libs/libfreetype.so*
}
