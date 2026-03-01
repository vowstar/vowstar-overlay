# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
inherit distutils-r1

MY_PN="kaldi_native_fbank"

DESCRIPTION="Kaldi-compatible online fbank feature extractor"
HOMEPAGE="
	https://github.com/csukuangfj/kaldi-native-fbank
	https://pypi.org/project/kaldi-native-fbank/
"

SRC_URI="
	python_targets_python3_11? (
		https://files.pythonhosted.org/packages/52/3f/beb161e4fdf6710938ccf18418c147d87ba8f102903d6c6e4eda25588e22/${MY_PN}-${PV}-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${MY_PN}-${PV}-cp311-cp311-linux_x86_64.whl
	)
	python_targets_python3_12? (
		https://files.pythonhosted.org/packages/84/90/01ef7331c52b1eaf9916f3f7a535155aac2e9e2ddad12a141613d92758c7/${MY_PN}-${PV}-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${MY_PN}-${PV}-cp312-cp312-linux_x86_64.whl
	)
	python_targets_python3_13? (
		https://files.pythonhosted.org/packages/bc/1e/496c7ae814b2a7f8f47d423dc33aae2cdfb1edf898e2faaf5c5b39b90363/${MY_PN}-${PV}-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${MY_PN}-${PV}-cp313-cp313-linux_x86_64.whl
	)
	python_targets_python3_14? (
		https://files.pythonhosted.org/packages/2b/6a/374ec4e1cf13e672f5acd8272116c1885c2a7f84be491fc652415fc6e870/${MY_PN}-${PV}-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${MY_PN}-${PV}-cp314-cp314-linux_x86_64.whl
	)
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist mirror strip test"

QA_PREBUILT="*"

python_compile() {
	local pyver="${EPYTHON/python/}"
	pyver="${pyver/./}"
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${MY_PN}-${PV}-cp${pyver}-cp${pyver}-linux_x86_64.whl"
}
