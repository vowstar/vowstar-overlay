# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN^}"
inherit distutils-r1 pypi

DESCRIPTION="A library for creating columnar output strings using data as input"
HOMEPAGE="
	https://github.com/MaxTaggart/columnar
	https://pypi.org/project/columnar/
"
S="${WORKDIR}/${PYPI_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"

# Tests not included in PyPI tarball
# https://github.com/MaxTaggart/columnar/tree/master/tests
RESTRICT="test"
