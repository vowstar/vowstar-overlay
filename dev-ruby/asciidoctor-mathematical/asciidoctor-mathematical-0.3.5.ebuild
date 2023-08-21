# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Alternative stem processor for asciidoctor based on Mathematical"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-mathematical"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OWL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/asciidoctor-2.0 <dev-ruby/asciidoctor-3
	>=dev-ruby/asciimath-2.0 <dev-ruby/asciimath-3.0
	>=dev-ruby/mathematical-1.6.0 <dev-ruby/mathematical-3
	"

all_ruby_prepare() {
	rm Gemfile || die

	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	all_fakegem_install
}
