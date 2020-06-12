# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_PN="container-toolkit"
EGO_PN="github.com/NVIDIA/${GITHUB_PN}"

inherit golang-build

DESCRIPTION="NVIDIA container runtime toolkit"
HOMEPAGE="https://github.com/NVIDIA/container-toolkit"

if [[ "${PV}" == "9999" ]] ; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
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
	echo "${S}" || die
	EGO_PN="${EGO_PN}/pkg" \
		EGO_BUILD_FLAGS="-o ${T}/${PN}" \
		golang-build_src_compile
}

src_install() {
	dobin "${T}/${PN}"
	dosym "bin/${PN}" "bin/nvidia-container-runtime-hook"
	cp "${S}/config/config.toml.debian" "${S}/config/config.toml" || die
	insinto /etc/nvidia-container-runtime
	doins "${S}/config/config.toml"
}
