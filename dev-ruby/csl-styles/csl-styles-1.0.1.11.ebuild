# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="vendor"
RUBY_FAKEGEM_GEMSPEC="csl-styles.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

COMMIT="ec26358947824de26ec8b13c63436d1e3122c1a6"
COMMIT_LOCALES="bd8d2dbc85713b192d426fb02749475df30f0d2c"
COMMIT_STYLES="9b9c74d04fbaab04fa942a932289f2b2e9b9d4ab"
CSL_URI="https://github.com/citation-style-language"

inherit ruby-fakegem

DESCRIPTION="CSL styles and locales as a RubyGem"
HOMEPAGE="https://github.com/inukshuk/csl-styles"
SRC_URI="
	https://github.com/inukshuk/csl-styles/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	${CSL_URI}/locales/archive/${COMMIT_LOCALES}.tar.gz -> ${PN}-locales-${COMMIT_LOCALES}.tar.gz
	${CSL_URI}/styles/archive/${COMMIT_STYLES}.tar.gz -> ${PN}-styles-${COMMIT_STYLES}.tar.gz
"
RUBY_S="${PN}-${COMMIT}"

LICENSE="AGPL-3 BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/csl-1.0 <dev-ruby/csl-2"

all_ruby_prepare() {
	rm -rf "${WORKDIR}/all/${RUBY_S}/vendor/locales" || die
	rm -rf "${WORKDIR}/all/${RUBY_S}/vendor/styles" || die
	cp -rf "${WORKDIR}/all/locales-${COMMIT_LOCALES}" "${WORKDIR}/all/${RUBY_S}/vendor/locales" || die
	cp -rf "${WORKDIR}/all/styles-${COMMIT_STYLES}" "${WORKDIR}/all/${RUBY_S}/vendor/styles" || die
}
