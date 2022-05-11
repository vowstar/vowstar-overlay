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
	sci-mathematics/octave-zeromq
"

DEPEND="${RDEPEND}"

pkg_postinst() {
	elog "Please append these to ~/.octaverc"
	elog "pkg load arduino"
	elog "pkg load audio"
	elog "pkg load bim"
	elog "pkg load bsltl"
	elog "pkg load cgi"
	elog "pkg load communications"
	elog "pkg load control"
	elog "pkg load data-smoothing"
	elog "pkg load database"
	elog "pkg load dataframe"
	elog "pkg load dicom"
	elog "pkg load divand"
	elog "pkg load doctest"
	elog "pkg load econometrics"
	elog "pkg load fem-fenics"
	elog "pkg load financial"
	elog "pkg load fits"
	elog "pkg load fpl"
	elog "pkg load fuzzy-logic-toolkit"
	elog "pkg load ga"
	elog "pkg load general"
	elog "pkg load generate_html"
	elog "pkg load geometry"
	elog "pkg load gsl"
	elog "pkg load image"
	elog "pkg load image-acquisition"
	elog "pkg load instrument-control"
	elog "pkg load interval"
	elog "pkg load io"
	elog "pkg load level-set"
	elog "pkg load linear-algebra"
	elog "pkg load lssa"
	elog "pkg load ltfat"
	elog "pkg load mapping"
	elog "pkg load matgeom"
	elog "pkg load miscellaneous"
	elog "pkg load msh"
	elog "pkg load mvn"
	elog "pkg load nan"
	elog "pkg load ncarray"
	elog "pkg load netcdf"
	elog "pkg load nurbs"
	elog "pkg load ocl"
	elog "pkg load ocs"
	elog "pkg load octclip"
	elog "pkg load octproj"
	elog "pkg load optics"
	elog "pkg load optim"
	elog "pkg load optiminterp"
	elog "pkg load parallel"
	elog "pkg load quaternion"
	elog "pkg load queueing"
	elog "pkg load secs1d"
	elog "pkg load secs2d"
	elog "pkg load secs3d"
	elog "pkg load signal"
	elog "pkg load sockets"
	elog "pkg load sparsersb"
	elog "pkg load splines"
	elog "pkg load statistics"
	elog "pkg load stk"
	elog "pkg load strings"
	elog "pkg load struct"
	elog "pkg load symbolic"
	elog "pkg load tisean"
	elog "pkg load tsa"
	elog "pkg load vibes"
	elog "pkg load video"
	elog "pkg load vrml"
	elog "pkg load zeromq"
}

pkg_postrm() {
	elog "Please remove these from ~/.octaverc"
	elog "pkg load arduino"
	elog "pkg load audio"
	elog "pkg load bim"
	elog "pkg load bsltl"
	elog "pkg load cgi"
	elog "pkg load communications"
	elog "pkg load control"
	elog "pkg load data-smoothing"
	elog "pkg load database"
	elog "pkg load dataframe"
	elog "pkg load dicom"
	elog "pkg load divand"
	elog "pkg load doctest"
	elog "pkg load econometrics"
	elog "pkg load fem-fenics"
	elog "pkg load financial"
	elog "pkg load fits"
	elog "pkg load fpl"
	elog "pkg load fuzzy-logic-toolkit"
	elog "pkg load ga"
	elog "pkg load general"
	elog "pkg load generate_html"
	elog "pkg load geometry"
	elog "pkg load gsl"
	elog "pkg load image"
	elog "pkg load image-acquisition"
	elog "pkg load instrument-control"
	elog "pkg load interval"
	elog "pkg load io"
	elog "pkg load level-set"
	elog "pkg load linear-algebra"
	elog "pkg load lssa"
	elog "pkg load ltfat"
	elog "pkg load mapping"
	elog "pkg load matgeom"
	elog "pkg load miscellaneous"
	elog "pkg load msh"
	elog "pkg load mvn"
	elog "pkg load nan"
	elog "pkg load ncarray"
	elog "pkg load netcdf"
	elog "pkg load nurbs"
	elog "pkg load ocl"
	elog "pkg load ocs"
	elog "pkg load octclip"
	elog "pkg load octproj"
	elog "pkg load optics"
	elog "pkg load optim"
	elog "pkg load optiminterp"
	elog "pkg load parallel"
	elog "pkg load quaternion"
	elog "pkg load queueing"
	elog "pkg load secs1d"
	elog "pkg load secs2d"
	elog "pkg load secs3d"
	elog "pkg load signal"
	elog "pkg load sockets"
	elog "pkg load sparsersb"
	elog "pkg load splines"
	elog "pkg load statistics"
	elog "pkg load stk"
	elog "pkg load strings"
	elog "pkg load struct"
	elog "pkg load symbolic"
	elog "pkg load tisean"
	elog "pkg load tsa"
	elog "pkg load vibes"
	elog "pkg load video"
	elog "pkg load vrml"
	elog "pkg load zeromq"
}
