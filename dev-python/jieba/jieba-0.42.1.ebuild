# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Chinese text segmentation library"
HOMEPAGE="
	https://github.com/fxsjy/jieba
	https://pypi.org/project/jieba/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# Tests not included in PyPI tarball
RESTRICT="test"
