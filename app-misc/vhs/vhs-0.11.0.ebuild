# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="CLI home video recorder for terminal sessions"
HOMEPAGE="
	https://github.com/charmbracelet/vhs/
	https://vhs.charm.sh/
"
SRC_URI="
	https://github.com/charmbracelet/vhs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/vowstar/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/ffmpeg
	www-apps/ttyd
	|| (
		www-client/chromium
		www-client/google-chrome
		www-client/google-chrome-beta
		www-client/google-chrome-unstable
	)
"
BDEPEND=">=dev-lang/go-1.25.8"

src_compile() {
	ego build -trimpath -ldflags "
		-linkmode external -extldflags '${LDFLAGS}' \
		-X main.Version=${PV}"
}

src_test() {
	ego test ./...
}

src_install() {
	dobin vhs

	# Generate and install shell completions
	./vhs completion bash > vhs.bash || die
	./vhs completion zsh > vhs.zsh || die
	./vhs completion fish > vhs.fish || die
	newbashcomp vhs.bash vhs
	newzshcomp vhs.zsh _vhs
	newfishcomp vhs.fish vhs

	# Install man page
	./vhs man > vhs.1 || die
	doman vhs.1
}
