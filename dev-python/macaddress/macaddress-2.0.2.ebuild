# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Like ipaddress, but for hardware identifiers such as MAC addresses"
HOMEPAGE="
	https://github.com/mentalisttraceur/python-macaddress
	https://pypi.org/project/macaddress/
"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# No test suite included in sdist
RESTRICT="test"
