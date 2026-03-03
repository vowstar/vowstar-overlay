# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="NumPy-aware optimizing compiler for Python using LLVM"
HOMEPAGE="
	https://github.com/numba/numba
	https://pypi.org/project/numba/
"

SRC_URI="
	python_targets_python3_11? (
		https://files.pythonhosted.org/packages/19/16/aa6e3ba3cd45435c117d1101b278b646444ed05b7c712af631b91353f573/${PN}-${PV}-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp311-cp311-linux_x86_64.whl
	)
	python_targets_python3_12? (
		https://files.pythonhosted.org/packages/9b/89/1a74ea99b180b7a5587b0301ed1b183a2937c4b4b67f7994689b5d36fc34/${PN}-${PV}-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp312-cp312-linux_x86_64.whl
	)
	python_targets_python3_13? (
		https://files.pythonhosted.org/packages/42/e8/14b5853ebefd5b37723ef365c5318a30ce0702d39057eaa8d7d76392859d/${PN}-${PV}-cp313-cp313-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp313-cp313-linux_x86_64.whl
	)
	python_targets_python3_14? (
		https://files.pythonhosted.org/packages/8e/4b/600b8b7cdbc7f9cebee9ea3d13bb70052a79baf28944024ffcb59f0712e3/${PN}-${PV}-cp314-cp314-manylinux2014_x86_64.manylinux_2_17_x86_64.whl
			-> ${PN}-${PV}-cp314-cp314-linux_x86_64.whl
	)
"

S="${WORKDIR}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/llvmlite-0.46.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.22[${PYTHON_USEDEP}]
"

RESTRICT="bindist mirror strip test"

QA_PREBUILT="*"

python_compile() {
	local pyver="${EPYTHON/python/}"
	pyver="${pyver/./}"
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${PN}-${PV}-cp${pyver}-cp${pyver}-linux_x86_64.whl"

	# Remove optional threading backends with unresolvable soname deps
	# (libgomp for OpenMP, libtbb for TBB); numba works without them
	rm -f "${BUILD_DIR}"/install/usr/lib/python*/site-packages/numba/np/ufunc/{omppool,tbbpool}*.so || true
}
