# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_BUILD_PV="18"

DESCRIPTION="VST 3 Plug-In SDK"
HOMEPAGE="https://github.com/steinbergmedia/vst3sdk"
SRC_URI="
	https://github.com/steinbergmedia/vst3sdk/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/steinbergmedia/vst3_base/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> vst3_base-${PV}.tar.gz
	https://github.com/steinbergmedia/vst3_cmake/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> vst3_cmake-${PV}.tar.gz
	https://github.com/steinbergmedia/vst3_doc/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> vst3_doc-${PV}.tar.gz
	https://github.com/steinbergmedia/vst3_pluginterfaces/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> vst3_pluginterfaces-${PV}.tar.gz
	https://github.com/steinbergmedia/vst3_public_sdk/archive/refs/tags/v${PV}_build_${MY_BUILD_PV}.tar.gz -> vst3_public_sdk-${PV}.tar.gz
	https://github.com/steinbergmedia/vstgui/archive/refs/tags/vstgui4_11_2.tar.gz -> vstgui-4.11.2.tar.gz
"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc"

S="${WORKDIR}/${PN}-${PV}_build_${MY_BUILD_PV}"
S_BASE="${WORKDIR}/vst3_base-${PV}_build_${MY_BUILD_PV}"
S_CMAKE="${WORKDIR}/vst3_cmake-${PV}_build_${MY_BUILD_PV}"
S_DOC="${WORKDIR}/vst3_doc-${PV}_build_${MY_BUILD_PV}"
S_PLUG="${WORKDIR}/vst3_pluginterfaces-${PV}_build_${MY_BUILD_PV}"
S_PUB="${WORKDIR}/vst3_public_sdk-${PV}_build_${MY_BUILD_PV}"
S_GUI="${WORKDIR}/vstgui-vstgui4_11_2"

DOCS=( "${S}/LICENSE.txt" )

src_prepare() {
	mv -f ${S_BASE}/* "${S}"/base/ || die
	mv -f ${S_CMAKE}/* "${S}"/cmake/ || die
	mv -f ${S_DOC}/* "${S}"/doc/ || die
	mv -f ${S_PLUG}/* "${S}"/pluginterfaces/ || die
	mv -f ${S_PUB}/* "${S}"/public.sdk/ || die
	mv -f ${S_GUI}/* "${S}"/vstgui4/ || die
}

# vst3sdk is a source code only package and does not need to be compiled
src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${FILESDIR}"/vst3sdk.pc

	if use doc; then
		newdoc "${S}/LICENSE.txt" LICENSE.txt
		newdoc "${S}"/base LICENSE.base.txt
		newdoc "${S}"/public.sdk/LICENSE.txt LICENSE.public.sdk.txt
		find "${S}"/doc -name ".git*" -exec rm -R {} \; || die
		dodoc -r "${S}"/doc/*
	else
		rm -r "${S}"/doc || die
	fi

	insinto /usr/share/vst3sdk
	doins -r "${S}"

	insinto /usr/"$(get_libdir)"/cmake/${PN}
	doins "${S}"/cmake/modules/*.cmake

	default
}
