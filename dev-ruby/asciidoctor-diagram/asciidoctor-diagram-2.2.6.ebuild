# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc LICENSE.txt README.adoc"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND+=" virtual/jre"
DEPEND+=" test? (
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	media-gfx/imagemagick[png,postscript]
	media-gfx/graphviz
	media-sound/lilypond
	sci-visualization/gnuplot
)"

ruby_add_rdepend ">=dev-ruby/asciidoctor-1.5.7 <dev-ruby/asciidoctor-3
	~dev-ruby/asciidoctor-diagram-ditaamini-1.0.3
	~dev-ruby/asciidoctor-diagram-plantuml-1.2023.4
	dev-ruby/rexml"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/c.formatter/ s:^:#:' spec/test_helper.rb || die
	# Avoid specs for unpackaged tools
	rm -f spec/{a2s,blockdiag,bpmn,bytefield,dpic,erd,mermaid,msc,nomnoml,pikchr,shaape,smcat,svgbob,symbolator,syntrax,umlet,vega,wavedrom}_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install
}
