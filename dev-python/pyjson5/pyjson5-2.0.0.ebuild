# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="JSON5 serializer and parser for Python 3 written in Cython"
HOMEPAGE="
	https://github.com/Kijewski/pyjson5
	https://pypi.org/project/pyjson5/
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

# Tests require git submodules (JSONTestSuite, json5-tests) not in PyPI tarball
# https://github.com/Kijewski/pyjson5/tree/main/third-party
RESTRICT="test"
