# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A simple, unified manner of accessing program properties"
HOMEPAGE="
	https://github.com/jackdewinter/application_properties
	https://pypi.org/project/application-properties/
"
S="${WORKDIR}/${PN//-/_}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# Tests require pytest_helpers.py and test/__init__.py which are not included in PyPI tarball
RESTRICT="test"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyjson5[${PYTHON_USEDEP}]
"
