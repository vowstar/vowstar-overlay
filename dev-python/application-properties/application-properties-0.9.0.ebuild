# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="${PN//-/_}"

DESCRIPTION="A simple, unified manner of accessing program properties"
HOMEPAGE="
	https://github.com/jackdewinter/application_properties
	https://pypi.org/project/application-properties/
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
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyjson5[${PYTHON_USEDEP}]
"

# The test suite only uses the built-in parametrize marker, so no pytest
# plugins are needed.  Declaring an empty set also disables plugin autoloading.
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	# Use the stdlib tomllib (identical API and error output, present since
	# py3.11) instead of the deprecated dev-python/tomli.  Rewrite both import
	# forms: the module aliases keep the tomli.* call sites, and the test
	# imports TOMLDecodeError from tomllib so its isinstance check still holds.
	local f
	while IFS= read -r -d '' f; do
		sed -i \
			-e 's/^import tomli$/import tomllib as tomli/' \
			-e 's/^from tomli import/from tomllib import/' \
			"${f}" || die
	done < <(grep -rlZ "tomli" --include=*.py .)
	distutils-r1_python_prepare_all
}

python_test() {
	# Remove pytest.ini addopts that require pytest-timeout and pytest-cov
	epytest -o addopts=
}
