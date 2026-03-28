# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Spatial data examples for use with Python geospatial libraries"
HOMEPAGE="
	https://geodatasets.readthedocs.io/
	https://github.com/geopandas/geodatasets
	https://pypi.org/project/geodatasets/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pooch[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

# Tests require network access to fetch remote datasets
RESTRICT="test"
