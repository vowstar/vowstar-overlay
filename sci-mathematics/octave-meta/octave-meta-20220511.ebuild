# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Merge this to pull in all octave forge packages"
HOMEPAGE="https://octave.sourceforge.io"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	sci-mathematics/octave-arduino
	sci-mathematics/octave-audio
	sci-mathematics/octave-bim
	sci-mathematics/octave-bsltl
	sci-mathematics/octave-cgi
	sci-mathematics/octave-communications
	sci-mathematics/octave-control
	sci-mathematics/octave-data-smoothing
	sci-mathematics/octave-database
	sci-mathematics/octave-dataframe
	sci-mathematics/octave-dicom
	sci-mathematics/octave-divand
	sci-mathematics/octave-doctest
	sci-mathematics/octave-econometrics
	sci-mathematics/octave-fem-fenics
	sci-mathematics/octave-financial
	sci-mathematics/octave-fits
	sci-mathematics/octave-fpl
	sci-mathematics/octave-fuzzy-logic-toolkit
	sci-mathematics/octave-ga
	sci-mathematics/octave-general
	sci-mathematics/octave-generate_html
	sci-mathematics/octave-geometry
	sci-mathematics/octave-gsl
	sci-mathematics/octave-image
	sci-mathematics/octave-image-acquisition
	sci-mathematics/octave-instrument-control
	sci-mathematics/octave-interval
	sci-mathematics/octave-io
	sci-mathematics/octave-level-set
	sci-mathematics/octave-linear-algebra
	sci-mathematics/octave-lssa
	sci-mathematics/octave-ltfat
	sci-mathematics/octave-mapping
	sci-mathematics/octave-matgeom
	sci-mathematics/octave-miscellaneous
	sci-mathematics/octave-msh
	sci-mathematics/octave-mvn
	sci-mathematics/octave-nan
	sci-mathematics/octave-ncarray
	sci-mathematics/octave-netcdf
	sci-mathematics/octave-nurbs
	sci-mathematics/octave-ocl
	sci-mathematics/octave-ocs
	sci-mathematics/octave-octclip
	sci-mathematics/octave-octproj
	sci-mathematics/octave-optics
	sci-mathematics/octave-optim
	sci-mathematics/octave-optiminterp
	sci-mathematics/octave-parallel
	sci-mathematics/octave-quaternion
	sci-mathematics/octave-queueing
	sci-mathematics/octave-secs1d
	sci-mathematics/octave-secs2d
	sci-mathematics/octave-secs3d
	sci-mathematics/octave-signal
	sci-mathematics/octave-sockets
	sci-mathematics/octave-sparsersb
	sci-mathematics/octave-splines
	sci-mathematics/octave-statistics
	sci-mathematics/octave-stk
	sci-mathematics/octave-strings
	sci-mathematics/octave-struct
	sci-mathematics/octave-symbolic
	sci-mathematics/octave-tisean
	sci-mathematics/octave-tsa
	sci-mathematics/octave-vibes
	sci-mathematics/octave-video
	sci-mathematics/octave-vrml
	sci-mathematics/octave-windows
	sci-mathematics/octave-zeromq
"

DEPEND="${RDEPEND}"
