# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="FRU Generator YAML - IPMI FRU binary data generator from YAML"
HOMEPAGE="
	https://techlab.desy.de
	https://pypi.org/project/frugy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/bitstruct-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/bidict-0.20.0[${PYTHON_USEDEP}]
	>=dev-python/macaddress-2.0.2[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

# Tests require all RDEPEND installed, works with emerge but not standalone ebuild
distutils_enable_tests pytest

src_prepare() {
	# requirements.txt missing from sdist but setup.py reads it
	cat > requirements.txt <<-EOF || die
		bitstruct>=8.0.0
		PyYAML>=5.1.0
		bidict>=0.20.0
		macaddress>=2.0.2
	EOF
	distutils-r1_src_prepare
}
