# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Merge this to pull in all octave forge packages"
HOMEPAGE="https://octave.sourceforge.io"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-octave/arduino
	dev-octave/audio
	dev-octave/bim
	dev-octave/bsltl
	dev-octave/cgi
	dev-octave/communications
	dev-octave/control
	dev-octave/data-smoothing
	dev-octave/dataframe
	dev-octave/divand
	dev-octave/doctest
	dev-octave/econometrics
	dev-octave/financial
	dev-octave/fpl
	dev-octave/fuzzy-logic-toolkit
	dev-octave/ga
	dev-octave/general
	dev-octave/generate_html
	dev-octave/gsl
	dev-octave/instrument-control
	dev-octave/interval
	dev-octave/io
	dev-octave/linear-algebra
	dev-octave/lssa
	dev-octave/mapping
	dev-octave/matgeom
	dev-octave/miscellaneous
	dev-octave/msh
	dev-octave/mvn
	dev-octave/nan
	dev-octave/ncarray
	dev-octave/netcdf
	dev-octave/nurbs
	dev-octave/ocl
	dev-octave/octclip
	dev-octave/octproj
	dev-octave/optics
	dev-octave/optim
	dev-octave/optiminterp
	dev-octave/parallel
	dev-octave/queueing
	dev-octave/secs1d
	dev-octave/secs3d
	dev-octave/signal
	dev-octave/sockets
	dev-octave/splines
	dev-octave/statistics
	dev-octave/stk
	dev-octave/struct
	dev-octave/symbolic
	dev-octave/tsa
	dev-octave/vrml
	dev-octave/zeromq
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
	elog "pkg load dataframe"
	elog "pkg load divand"
	elog "pkg load doctest"
	elog "pkg load econometrics"
	elog "pkg load financial"
	elog "pkg load fpl"
	elog "pkg load fuzzy-logic-toolkit"
	elog "pkg load ga"
	elog "pkg load general"
	elog "pkg load generate_html"
	elog "pkg load gsl"
	elog "pkg load instrument-control"
	elog "pkg load interval"
	elog "pkg load io"
	elog "pkg load linear-algebra"
	elog "pkg load lssa"
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
	elog "pkg load octclip"
	elog "pkg load octproj"
	elog "pkg load optics"
	elog "pkg load optim"
	elog "pkg load optiminterp"
	elog "pkg load parallel"
	elog "pkg load queueing"
	elog "pkg load secs1d"
	elog "pkg load secs3d"
	elog "pkg load signal"
	elog "pkg load sockets"
	elog "pkg load splines"
	elog "pkg load statistics"
	elog "pkg load stk"
	elog "pkg load struct"
	elog "pkg load symbolic"
	elog "pkg load tsa"
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
	elog "pkg load dataframe"
	elog "pkg load divand"
	elog "pkg load doctest"
	elog "pkg load econometrics"
	elog "pkg load financial"
	elog "pkg load fpl"
	elog "pkg load fuzzy-logic-toolkit"
	elog "pkg load ga"
	elog "pkg load general"
	elog "pkg load generate_html"
	elog "pkg load gsl"
	elog "pkg load instrument-control"
	elog "pkg load interval"
	elog "pkg load io"
	elog "pkg load linear-algebra"
	elog "pkg load lssa"
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
	elog "pkg load octclip"
	elog "pkg load octproj"
	elog "pkg load optics"
	elog "pkg load optim"
	elog "pkg load optiminterp"
	elog "pkg load parallel"
	elog "pkg load queueing"
	elog "pkg load secs1d"
	elog "pkg load secs3d"
	elog "pkg load signal"
	elog "pkg load sockets"
	elog "pkg load splines"
	elog "pkg load statistics"
	elog "pkg load stk"
	elog "pkg load struct"
	elog "pkg load symbolic"
	elog "pkg load tsa"
	elog "pkg load vrml"
	elog "pkg load zeromq"
}
