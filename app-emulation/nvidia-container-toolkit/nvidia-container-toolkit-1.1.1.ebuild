# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_PN="container-toolkit"

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
	S="${WORKDIR}/${GITHUB_PN}-${PV}"
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
	GOPATH="${WORKDIR}/${P}" \
	go install -v \
	-buildmode=pie \
	-gcflags "all=-trimpath=${S}" \
	-asmflags "all=-trimpath=${S}" \
    -ldflags "-s -w -extldflags ${LDFLAGS}" \
    -o "${PN}" \
	"github.com/NVIDIA/${GITHUB_PN}/pkg" || die
}

src_install() {
	dobin bin/*
	dosym "bin/${PN}" "bin/nvidia-container-runtime-hook"
	insinto /etc/nvidia-container-runtime
	cp "${S}/config/config.toml.debian" "${S}/config/config.toml" || die
	doins "${S}/config/config.toml"
}
