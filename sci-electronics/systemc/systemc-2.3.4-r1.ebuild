# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV}_pub_rev_20190614"

inherit autotools

DESCRIPTION="A C++ based modeling platform for VLSI and system-level co-design"
HOMEPAGE="
	https://accellera.org/community/systemc
	https://github.com/accellera-official/systemc
"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/accellera-official/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/accellera-official/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="debug doc examples static-libs test"
REQUIRED_USE="examples? ( doc )"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	eautoconf --force
}

src_configure() {
	econf CXX=$(tc-getCXX) \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		--with-unix-layout
}

src_install() {
	if use doc; then
		DOCS=(AUTHORS.md CONTRIBUTING.md INSTALL.md LICENSE NOTICE README.md RELEASENOTES)
		if use examples; then
			docompress -x /usr/share/doc/"${P}"/examples
		else
			rm -r "${ED}"/usr/share/doc/"${P}"/examples
		fi
	else
		rm -r "${ED}"/usr/share/doc/"${P}"
	fi
	default
}

pkg_postinst() {
	if use examples; then
		elog "If you want to run the examples, you need to :"
		elog "    tar xvfz ${PORTAGE_ACTUAL_DISTDIR}/${A}"
		elog "    cd ${PN}-${MY_PV}"
		elog "    mkdir build && cd build"
		elog "    cmake .."
		elog "    cd examples"
		elog "    make check"
	fi
}
