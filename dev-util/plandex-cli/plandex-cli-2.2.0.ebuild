# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# workaround for go.mod replace directives plandex-shared
NONFATAL_VERIFY=1

inherit go-module

DESCRIPTION="AI-powered coding assistant that helps you with complex tasks"
HOMEPAGE="https://plandex.ai/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/plandex-ai/plandex.git"
else
	SRC_URI="
		https://github.com/plandex-ai/plandex/archive/refs/tags/cli/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/vowstar/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
	"
	S="${WORKDIR}/${PN}-v${PV}/app/cli"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"

src_compile() {
	ego build -o "bin/plandex"
}

src_test() {
	ego test ./...
}

src_install() {
	dobin "bin/plandex"
	dosym plandex /usr/bin/pdx
}
