# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Provides support for icons in Prawn"
HOMEPAGE="https://github.com/jessedoyle/prawn-icon"
LICENSE="|| ( GPL-2+ GPL-3 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
# Tests blocks many keywords and new dependencies, skipping for now
RESTRICT=test

ruby_add_rdepend ">=dev-ruby/prawn-1.1.0"
