# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_PN="container-toolkit"
EGO_PN="github.com/NVIDIA/${GITHUB_PN}"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="NVIDIA container runtime toolkit"
HOMEPAGE="https://github.com/NVIDIA/container-toolkit"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NVIDIA/${GITHUB_PN}.git"
else
	SRC_URI="
		https://github.com/NVIDIA/${GITHUB_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

IUSE=""

RDEPEND="
	app-emulation/libnvidia-container
"

DEPEND="${RDEPEND}"

BDEPEND=""

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" \
	go install -v \
	-buildmode=pie \
	-gcflags "all=-trimpath=${S}" \
	-asmflags "all=-trimpath=${S}" \
    -ldflags "-s -w -extldflags ${LDFLAGS}" \
    -o "${PN}" \
	"${EGO_PN}/pkg" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/*
	dosym "bin/${PN}" "bin/nvidia-container-runtime-hook"
	insinto /etc/nvidia-container-runtime
	cp "config/config.toml.debian" "config/config.toml" || die
	doins "config/config.toml"
	popd || die
}
