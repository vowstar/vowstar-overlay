# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO="https://github.com/geopandas/geopandas"
inherit distutils-r1 pypi

DESCRIPTION="Python tools for geographic data"
HOMEPAGE="
	https://geopandas.org/
	https://github.com/geopandas/geopandas
	https://pypi.org/project/geopandas/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.24[${PYTHON_USEDEP}]
	>=dev-python/pyogrio-0.7.2[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pandas-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyproj-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/shapely-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
