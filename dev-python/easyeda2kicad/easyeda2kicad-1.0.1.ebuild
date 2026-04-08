# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Convert electronic components from LCSC/EasyEDA to KiCad libraries"
HOMEPAGE="
	https://github.com/uPesy/easyeda2kicad.py
	https://pypi.org/project/easyeda2kicad/
"
SRC_URI="https://github.com/uPesy/easyeda2kicad.py/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/easyeda2kicad.py-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# These tests require network access to LCSC/EasyEDA API
	tests/test_easyeda_api.py
	tests/test_jlcpcb_search.py
	tests/test_regression.py
	tests/test_custom_fields.py
	tests/test_datasheet_fallback.py
	tests/test_svg_renderer.py
)
