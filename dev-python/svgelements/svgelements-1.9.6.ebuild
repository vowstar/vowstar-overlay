# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="SVG parsing and generation library for Python"
HOMEPAGE="https://github.com/meerk40t/svgelements https://pypi.org/project/svgelements/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Deprecated unittest aliases removed in Python 3.12+
EPYTEST_DESELECT=(
	test/test_cubic_bezier.py::TestElementCubicBezierPoint::test_cubic_bounds_issue_220
	test/test_write.py::TestElementWrite::test_write_group
)

src_prepare() {
	default
	# Exclude stray test package from installation
	printf '[options.packages.find]\nexclude = test*\n' >> setup.cfg || die
}

distutils_enable_tests pytest
