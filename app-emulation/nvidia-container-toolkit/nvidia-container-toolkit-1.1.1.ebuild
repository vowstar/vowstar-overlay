# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_PN="container-toolkit"
EGO_PN_VCS="github.com/NVIDIA/${GITHUB_PN}"
EGO_PN="${EGO_PN_VCS}"

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
	EGO_PN="${EGO_PN_VCS}/pkg" \
		EGO_BUILD_FLAGS="-o ${T}/${PN}" \
		golang-build_src_compile
}

src_install() {
	dobin "${T}/${PN}"
	dosym "/usr/bin/${PN}" "/usr/bin/nvidia-container-runtime-hook"
	pushd "src/${EGO_PN}" >/dev/null || die
	cp "config/config.toml.debian" "config/config.toml" || die
	insinto "/etc/nvidia-container-runtime"
	doins "config/config.toml"
	popd >/dev/null || die
}
