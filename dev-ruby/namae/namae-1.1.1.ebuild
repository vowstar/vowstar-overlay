# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="namae.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

COMMIT="bfe0422871cb30c50b6008fadafa50dd9dcda806"

inherit ruby-fakegem

DESCRIPTION="Namae (名前) is a parser for human names"
HOMEPAGE="https://github.com/berkmancenter/namae"
SRC_URI="https://github.com/berkmancenter/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-${COMMIT}"

LICENSE="AGPL-3 BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/racc-1.4"
