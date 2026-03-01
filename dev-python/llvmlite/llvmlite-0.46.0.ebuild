# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="Lightweight LLVM Python binding for writing JIT compilers"
HOMEPAGE="
	https://github.com/numba/llvmlite
	https://pypi.org/project/llvmlite/
"

SRC_URI="
	python_targets_python3_11? (
		https://files.pythonhosted.org/packages/12/b5/99cf8772fdd846c07da4fd70f07812a3c8fd17ea2409522c946bb0f2b277/${PN}-${PV}-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp311-cp311-linux_x86_64.whl
	)
	python_targets_python3_12? (
		https://files.pythonhosted.org/packages/aa/85/4890a7c14b4fa54400945cb52ac3cd88545bbdb973c440f98ca41591cdc5/${PN}-${PV}-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp312-cp312-linux_x86_64.whl
	)
	python_targets_python3_13? (
		https://files.pythonhosted.org/packages/0e/54/737755c0a91558364b9200702c3c9c15d70ed63f9b98a2c32f1c2aa1f3ba/${PN}-${PV}-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp313-cp313-linux_x86_64.whl
	)
	python_targets_python3_14? (
		https://files.pythonhosted.org/packages/c9/19/5018e5352019be753b7b07f7759cdabb69ca5779fea2494be8839270df4c/${PN}-${PV}-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp314-cp314-linux_x86_64.whl
	)
"

S="${WORKDIR}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist mirror strip test"

QA_PREBUILT="*"

python_compile() {
	local pyver="${EPYTHON/python/}"
	pyver="${pyver/./}"
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${PN}-${PV}-cp${pyver}-cp${pyver}-linux_x86_64.whl"
}
