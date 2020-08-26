# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop multilib unpacker xdg

DESCRIPTION="Wolfram Mathematica"
SRC_URI="Mathematica_${PV}_LINUX.sh"
HOMEPAGE="https://www.wolfram.com/mathematica/"

LICENSE="all-rights-reserved"
KEYWORDS="-* ~amd64"
SLOT="0"
IUSE="+doc"

RESTRICT="strip mirror bindist fetch"

DEPEND=""

# Mathematica comes with a lot of bundled stuff. We should place here only what we
# explicitly override with LD_PRELOAD.
RDEPEND="
	media-libs/freetype
"

# we need this a few times
MPN="Mathematica"
MPV=$(ver_cut 1-2)
M_BINARIES="MathKernel Mathematica MathematicaScript WolframKernel WolframScript math mathematica mcc wolfram"
M_TARGET="opt/Wolfram/${MPN}/${MPV}"

# we might as well list all files in all QA variables...
QA_PREBUILT="opt/*"

S=${WORKDIR}

src_unpack() {
	unpack_makeself
}

src_prepare() {
	# fix ACCESS DENIED issue when installer check the avahi-daemon
	die
	sed -e "s:avahi-daemon -c:true:g" \
		"${DISTDIR}/${A}" \
			| SETUP_NOCHECK=1 /bin/sh /dev/stdin \
			--nox11 --confirm -- -auto "-targetdir=${S}/${M_TARGET}" "-execdir=${S}/opt/bin" || die
}

src_install() {
	local ARCH='-x86-64'

	if ! use doc; then
		einfo "Removing documentation"
		rm -r "${S}/${M_TARGET}/Documentation"
	fi

	einfo 'Removing MacOS- and Windows-specific files'
	find AddOns SystemFiles -type d -\( -name Windows -o -name Windows-x86-64 \
		-o -name MacOSX -o -name MacOSX-x86-64 -\) -delete

	# move all over
	mv "${S}"/opt "${D}"/opt || die

	# the autogenerated symlinks point into sandbox, remove
	rm "${D}"/opt/bin/* || die

	# install wrappers instead
	for name in ${M_BINARIES} ; do
		einfo "Generating wrapper for ${name}"
		echo '#!/bin/sh' >> "${T}/${name}"
		echo "LD_PRELOAD=/usr/$(get_libdir)/libfreetype.so.6:/$(get_libdir)/libz.so.1 /${M_TARGET}/Executables/${name} \$*" \
			>> "${T}/${name}"
		dobin "${T}/${name}"
	done
	for name in ${M_BINARIES} ; do
		einfo "Symlinking ${name} to /opt/bin"
		dosym ../../usr/bin/${name} /opt/bin/${name}
	done

	# fix some embedded paths and install desktop files
	for filename in $(find "${D}/${M_TARGET}/SystemFiles/Installation" -name "wolfram-mathematica.desktop") ; do
		echo Fixing "${filename}"
		sed -e "s:${S}::g" -e 's:^\t\t::g' -i "${filename}"
		echo "Categories=Physics;Science;Engineering;2DGraphics;Graphics;" >> "${filename}"
		domenu "${filename}"
	done

	# install mime types
	insinto /usr/share/mime/application
	for filename in $(find "${D}/${M_TARGET}/SystemFiles/Installation" -name "application-*.xml"); do
		basefilename=$(basename "${filename}")
		mv "${filename}" "${T}/${basefilename#application-}"
		doins "${T}/${basefilename#application-}"
	done
}

pkg_nofetch() {
	einfo "Please place the Wolfram Mathematica installation file ${SRC_URI}"
	einfo "in your \$\{DISTDIR\}."
	einfo "Note that to actually run and use Mathematica you need a valid license."
	einfo "Wolfram provides time-limited evaluation licenses at ${HOMEPAGE}"
}
