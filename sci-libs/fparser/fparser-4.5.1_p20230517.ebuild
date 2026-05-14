# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="a95217921440e399bb7e70ef012eb9c4f064a3a9"

DESCRIPTION="Function parser library (openEMS-compatible fork)"
HOMEPAGE="https://github.com/thliebig/fparser"
SRC_URI="https://github.com/thliebig/fparser/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fparser-${COMMIT}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
