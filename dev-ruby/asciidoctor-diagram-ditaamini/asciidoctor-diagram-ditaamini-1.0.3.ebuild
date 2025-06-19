# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="asciidoctor-diagram"
MY_PV="2.2.6"
USE_RUBY="ruby32 ruby33 ruby34"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="ditaamini-license.txt"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"
RUBY_S="${MY_PN}-${MY_PV}/deps/ditaa"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# This subproject have no tests
RESTRICT="test"
RDEPEND+=" virtual/jre"
