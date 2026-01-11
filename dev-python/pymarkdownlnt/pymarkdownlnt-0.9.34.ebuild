# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A GitHub Flavored Markdown compliant Markdown linter"
HOMEPAGE="
	https://github.com/jackdewinter/pymarkdown
	https://pypi.org/project/pymarkdownlnt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# Tests require test/utils.py, test/__init__.py and test subdirectories not included in PyPI tarball
RESTRICT="test"

RDEPEND="
	>=dev-python/application-properties-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/columnar-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"
