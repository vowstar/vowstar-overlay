# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://kicad.github.io/packages3d/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-packages3D.git"
	inherit autotools git-r3
else
	SRC_URI="https://gitlab.com/kicad/libraries/kicad-packages3D/-/archive/${PV}/kicad-packages3D-${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="+occ oce"

REQUIRED_USE="|| ( occ oce )"

RDEPEND=">=sci-electronics/kicad-5.1.9[occ=,oce=]"

CHECKREQS_DISK_BUILD="11G"
