# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO="https://github.com/geopandas/pyogrio"
inherit distutils-r1 pypi

DESCRIPTION="Vectorized spatial vector file format I/O using GDAL/OGR"
HOMEPAGE="
	https://pyogrio.readthedocs.io/
	https://github.com/geopandas/pyogrio
	https://pypi.org/project/pyogrio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	sci-libs/gdal
"
DEPEND="
	sci-libs/gdal
"
BDEPEND="
	>=dev-python/cython-3.1[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	sci-libs/gdal
"

distutils_enable_tests pytest
