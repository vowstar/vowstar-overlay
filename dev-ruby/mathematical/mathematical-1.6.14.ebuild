# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="LICENSE.txt README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Quickly convert math equations into beautiful SVG (or PNG/MathML)"
HOMEPAGE="https://github.com/gjtorikian/mathematical"
SRC_URI="https://github.com/gjtorikian/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/ruby-enum-0.4"
ruby_add_bdepend ">=dev-ruby/math-to-itex-0.3
	>=dev-ruby/minitest-5.6
	>=dev-ruby/nokogiri-1.10
	>=dev-ruby/pry-byebug-3.9.0
	"
