# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Codex - OpenAI's code generation and completion tool"
HOMEPAGE="https://github.com/openai/codex"
SRC_URI="https://github.com/openai/codex/releases/download/rust-v${PV}/codex-x86_64-unknown-linux-musl.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist mirror strip"

QA_PREBUILT="usr/bin/codex"

src_install() {
	mv codex-x86_64-unknown-linux-musl codex || die
	dobin codex
}
