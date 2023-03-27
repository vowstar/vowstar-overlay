# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

PN_LASEM="lasem"
PV_LASEM="0.5.1"
PN_MTEX2MML="mtex2MML"
PV_MTEX2MML="1.3.1"

RUBY_FAKEGEM_EXTRADOC="LICENSE.txt README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="Quickly convert math equations into beautiful SVG (or PNG/MathML)"
HOMEPAGE="https://github.com/gjtorikian/mathematical"
SRC_URI="
	https://github.com/gjtorikian/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/LasemProject/lasem/archive/${PN_LASEM^^}_${PV_LASEM//./_}.tar.gz \
		-> ${P}-${PN_LASEM}-${PV_LASEM}.tar.gz
	https://github.com/gjtorikian/mtex2MML/archive/v${PV_MTEX2MML}.tar.gz -> ${P}-${PN_MTEX2MML}-${PV_MTEX2MML}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/ruby-enum-0.4"
ruby_add_bdepend ">=dev-ruby/math-to-itex-0.3
	>=dev-ruby/minitest-5.6
	>=dev-ruby/nokogiri-1.10
	>=dev-ruby/pry-byebug-3.9.0
	"

RDEPEND+=" dev-libs/libxml2 x11-libs/pango"
BDEPEND+=" dev-util/patchelf"

all_ruby_prepare() {
	rm -rf "${WORKDIR}/all/${P}/ext/${PN}/lasem" || die
	rm -rf "${WORKDIR}/all/${P}/ext/${PN}/mtex2MML" || die
	# Use cp instead of ln because the latter doesn't work with symlinks
	cp -rf "${WORKDIR}/all/${PN_LASEM}-${PN_LASEM^^}_${PV_LASEM//./_}" \
		"${WORKDIR}/all/${P}/ext/${PN}/${PN_LASEM}" || die
	cp -rf "${WORKDIR}/all/${PN_MTEX2MML}-${PV_MTEX2MML}" \
		"${WORKDIR}/all/${P}/ext/${PN}/${PN_MTEX2MML}" || die
}

each_ruby_configure() {
	"${RUBY}" -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/${PN} V=1
	local MY_RPATH="${EROOT}/$(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/lib/${PN}"
	patchelf --set-rpath "${MY_RPATH}" "ext/${PN}/${PN}$(get_modname)" || die
	cp "ext/${PN}/${PN}$(get_modname)" "lib/${PN}" || die
	cp "ext/${PN}/lib/lib${PN_LASEM}$(get_modname)" "lib/${PN}" || die
}

each_ruby_test() {
	"${RUBY}" -Ilib -S rake test || die
}
