# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="csl-styles.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

COMMIT="678a9e811e272940af595326b4dc0437695c5b3c"

inherit ruby-fakegem

DESCRIPTION="CSL styles and locales as a RubyGem"
HOMEPAGE="https://github.com/inukshuk/csl-styles"
SRC_URI="https://github.com/inukshuk/csl-styles/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="AGPL-3 BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/csl-2.0"
