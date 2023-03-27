# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.adoc"
RUBY_FAKEGEM_EXTRAINSTALL="lib"
RUBY_FAKEGEM_GEMSPEC="asciidoctor-bibtex.gemspec"

inherit ruby-fakegem

DESCRIPTION="Add bibtex citation support for asciidoc documents"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-bibtex"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OWL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# rake have no task test, skipping for now
RESTRICT=test

ruby_add_rdepend "
	>=dev-ruby/asciidoctor-2.0
	>=dev-ruby/bibtex-ruby-4
	>=dev-ruby/citeproc-ruby-1
	>=dev-ruby/csl-styles-1
	>=dev-ruby/latex-decode-0.2
	"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	)"
