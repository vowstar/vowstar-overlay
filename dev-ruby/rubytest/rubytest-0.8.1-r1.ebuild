# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby Test is a universal test harness for Ruby"
HOMEPAGE="https://rubyworks.github.io/rubytest/"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_bdepend "test? ( dev-ruby/ae dev-ruby/qed )"

ruby_add_rdepend "dev-ruby/ansi"

all_ruby_prepare() {
	# Help qed correctly find the root of the project
	touch .ruby || die
}

each_ruby_test() {
	${RUBY} -S qed || die 'tests failed'
}
