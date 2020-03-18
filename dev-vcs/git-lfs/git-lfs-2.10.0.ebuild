# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/${PN}/${PN}"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://${EGO_PN}"
	inherit git-r3
else
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux ~x86-linux"
fi

HOMEPAGE="https://git-lfs.github.com/"
DESCRIPTION="command line extension and specification for managing large files with Git"
LICENSE="Apache-2.0 BSD BSD-2 BSD-4 ISC MIT"

SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/go
	doc? ( app-text/ronn )
"
RDEPEND="dev-vcs/git"

QA_FLAGS_IGNORED="/usr/bin/git-lfs"

src_compile() {
	set -- go build \
		-ldflags="-X ${EGO_PN}/config.GitCommit=${GIT_COMMIT}" \
		-mod vendor -v -work -x \
		-o git-lfs git-lfs.go
	echo "$@"
	"$@" || die

	if use doc; then
		ronn docs/man/*.ronn || die "man building failed"
	fi
}

src_install() {
	dobin git-lfs
	dodoc {CHANGELOG,CODE-OF-CONDUCT,CONTRIBUTING,README}.md
	use doc && doman docs/man/*.1
}
