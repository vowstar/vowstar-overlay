# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="citeproc-ruby.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A cite processor interface for Citation Style Language (CSL)"
HOMEPAGE="https://github.com/inukshuk/citeproc-ruby"
SRC_URI="https://github.com/inukshuk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/citeproc-1.0 <dev-ruby/citeproc-2
	>=dev-ruby/csl-1.0"
