# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="pymarkdown"

DESCRIPTION="A GitHub Flavored Markdown compliant Markdown linter"
HOMEPAGE="
	https://github.com/jackdewinter/pymarkdown
	https://pypi.org/project/pymarkdownlnt/
"
SRC_URI="
	https://github.com/jackdewinter/${MY_PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/application-properties-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/columnar-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# Remove pytest.ini addopts that require pytest-timeout and pytest-cov
	epytest -o addopts=
}
