# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby implementation of the Rc4 algorithm"
HOMEPAGE="https://github.com/caiges/Ruby-RC4"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

all_ruby_prepare() {
	sed -i -e 's/"README"/"README.md"/' Rakefile || die
}
