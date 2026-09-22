# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python client library for the Copr build service"
HOMEPAGE="
	https://github.com/fedora-copr/copr
	https://pypi.org/project/copr/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
"

# dev-python/requests-gssapi is not packaged in ::gentoo
EPYTEST_DESELECT=(
	copr/test/client_v3/test_auth.py::TestAuth::test_auth_from_config
	copr/test/client_v3/test_auth.py::TestGssApi
)

EPYTEST_PLUGINS=( )
distutils_enable_tests pytest
