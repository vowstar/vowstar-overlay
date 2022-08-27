# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PV="$(ver_cut 1)/$(ver_cut 2)/$(ver_cut 3)"
MY_LLVM_PV="fe0f72d5c55a9b95c5564089e946e8f08112e995"
CMAKE_BUILD_TYPE="Release"
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-r1

DESCRIPTION="The fast free Verilog/SystemVerilog simulator"
HOMEPAGE="
	https://circt.llvm.org
	https://github.com/llvm/circt
"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/llvm/${PN}.git"
	EGIT_SUBMODULES=( '*' )
else
	SRC_URI="
		https://github.com/llvm/circt/archive/refs/tags/sifive/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://github.com/llvm/llvm-project/archive/${MY_LLVM_PV}.tar.gz -> llvm-project-${MY_LLVM_PV}.tar.gz
	"
	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-sifive-$(ver_cut 1)-$(ver_cut 2)-$(ver_cut 3)"
	S_LLVM="${WORKDIR}/llvm-project-${MY_LLVM_PV}"
fi

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD public-domain rc"
SLOT="0"
REQUIRED_USE=" ${PYTHON_REQUIRED_USE} "

RDEPEND="
	${PYTHON_DEPS}
	sys-libs/ncurses:0=
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	dev-util/ninja
	virtual/pkgconfig
"

DOCS=(
	"${S}/circt/llvm/llvm/LICENSE.TXT"
	"${S}/circt/llvm/mlir/LICENSE.TXT"
	"${S}/circt/LICENSE"
)

src_prepare() {
	default
	if [[ "${PV}" != "9999" ]] ; then
		rm -r ${S}/llvm || die
		ln -s ${S_LLVM} ${S}/llvm || die
	fi
}

src_configure() {
	python_setup

	local mycmakeargs=(
		-S ${S}/circt/llvm/llvm \
		-D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_INSTALL_PREFIX=/usr \
		-D LLVM_BINUTILS_INCDIR=/usr/include \
		-D LLVM_ENABLE_PROJECTS=mlir \
		-D BUILD_SHARED_LIBS=OFF \
		-D LLVM_STATIC_LINK_CXX_STDLIB=ON \
		-D LLVM_ENABLE_ASSERTIONS=ON \
		-D LLVM_BUILD_EXAMPLES=OFF \
		-D LLVM_ENABLE_BINDINGS=OFF \
		-D LLVM_ENABLE_OCAMLDOC=OFF \
		-D LLVM_OPTIMIZED_TABLEGEN=ON \
		-D LLVM_EXTERNAL_PROJECTS=circt \
		-D LLVM_EXTERNAL_CIRCT_SOURCE_DIR=${S}/circt \
		-D LLVM_BUILD_TOOLS=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_build
	eninja -C "${BUILD_DIR}" firtool
}

src_install() {
	einstalldocs
	exeinto /usr/bin
	doexe "${BUILD_DIR}"/bin/firtool
}
