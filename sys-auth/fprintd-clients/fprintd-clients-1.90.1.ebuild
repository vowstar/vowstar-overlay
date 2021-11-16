# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="e9b35caadf84a24842782fe3737e8207fd92c479"

inherit meson pam systemd

DESCRIPTION="D-Bus clients to access fingerprint readers"
HOMEPAGE="https://gitlab.freedesktop.org/uunicorn/fprintd"
SRC_URI="https://gitlab.freedesktop.org/uunicorn/fprintd/-/archive/${EGIT_COMMIT}/fprintd-${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE="doc pam systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	!sys-auth/fprintd
	sys-auth/libfprint:2
	sys-auth/polkit
	pam? (
		systemd? ( sys-apps/systemd )
		!systemd? ( sys-auth/elogind )
		sys-libs/pam
	)
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-lang/perl
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gtk-doc
	)
	test? (
		dev-python/dbusmock
		dev-python/dbus-python
		dev-python/pycairo
		pam? ( sys-libs/pam_wrapper )
	)
	virtual/pkgconfig
"
# These files already installed by open-fprintd
# /usr/share/dbus-1/system.d/net.reactivated.Fprint.conf
# /usr/share/dbus-1/system-services/net.reactivated.Fprint.service
# To avoid file collisions, fixed by fix-file-collisions.patch
PATCHES=(
	"${FILESDIR}/${PN}-1.90.1-add-meson-build-libsystemd-test.patch"
	"${FILESDIR}/${PN}-1.90.1-add-meson-options-libsystemd-test.patch"
	"${FILESDIR}/${PN}-1.90.1-fix-file-collisions.patch" # fix file collisions
)

S="${WORKDIR}/fprintd-${EGIT_COMMIT}"

src_configure() {
		local emesonargs=(
			$(meson_feature test)
			$(meson_use pam)
			-Dgtk_doc=$(usex doc true false)
			-Dman=true
			-Dsystemd_system_unit_dir=$(systemd_get_systemunitdir)
			-Dpam_modules_dir=$(getpam_mod_dir)
			-Dlibsystemd=$(usex systemd libsystemd libelogind)
		)
		meson_src_configure
}

src_install() {
	meson_src_install

	dodoc AUTHORS NEWS README TODO
	newdoc pam/README README.pam_fprintd
}

pkg_postinst() {
	elog "Please take a look at README.pam_fprintd for integration docs."
	elog "Please add yourself to input group."
}
