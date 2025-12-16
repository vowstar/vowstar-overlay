# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Colorado University binary Decision Diagram library"
HOMEPAGE="https://github.com/davidkebo/cudd"
SRC_URI="https://github.com/davidkebo/cudd/raw/main/cudd_versions/${PN}-${PV%%-*}.tar.gz"
S="${WORKDIR}/${PN}-${PV%%-*}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

src_configure() {
	local myconf=(
		--enable-dddmp
		--enable-obj
		--enable-shared
	)
	econf "${myconf[@]}"
}

src_compile() {
	# Build library via all-am target (excludes docs)
	emake all-am

	if use doc; then
		# Documentation build may fail with certain doxygen + GCC combinations
		# due to std::string_view assertion failures
		emake html || ewarn "HTML documentation build failed"
		emake -C doc cudd.pdf || ewarn "PDF documentation build failed"
	fi
}

src_install() {
	default
	find "${ED}" -name "*.la" -type f -delete || die

	if use doc; then
		[[ -d html ]] && dodoc -r html
		[[ -f doc/cudd.pdf ]] && dodoc doc/cudd.pdf
	fi
}
