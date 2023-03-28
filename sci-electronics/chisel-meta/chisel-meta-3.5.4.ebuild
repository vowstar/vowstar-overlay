# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package to run chisel playground"
HOMEPAGE="https://github.com/chipsalliance/playground"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"

if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND="
	dev-java/antlr:4
	dev-java/mill-bin
	dev-java/sbt-bin
	dev-libs/protobuf
	dev-ruby/asciidoctor
	dev-ruby/asciidoctor-bibtex
	dev-ruby/asciidoctor-diagram
	dev-ruby/asciidoctor-mathematical
	dev-ruby/asciidoctor-pdf
	dev-vcs/git
	net-misc/wget
	sci-electronics/circt
	sci-electronics/wavedrom-cli
	sys-apps/dtc
	sys-devel/make
	sys-process/parallel
"
