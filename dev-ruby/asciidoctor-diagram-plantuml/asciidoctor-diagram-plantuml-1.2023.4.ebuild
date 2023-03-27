# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="asciidoctor-diagram"
MY_PV="2.2.6"

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="plantuml-license.txt jlatexmath-license.txt batik-all-license.txt"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"
RUBY_S="${MY_PN}-${MY_PV}/deps/plantuml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# This subproject have no tests
RESTRICT="test"

RDEPEND+=" virtual/jre"
