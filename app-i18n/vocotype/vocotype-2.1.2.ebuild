# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 multiprocessing systemd xdg-utils

DESCRIPTION="Linux offline voice input method based on FunASR Paraformer"
HOMEPAGE="https://github.com/LeonardNJU/VocoType-linux"

SRC_URI="
	https://github.com/LeonardNJU/VocoType-linux/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}/VocoType-linux-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+fcitx ibus rime systemd"
REQUIRED_USE="
	|| ( ibus fcitx )
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	dev-python/sounddevice[${PYTHON_USEDEP}]
	dev-python/librosa[${PYTHON_USEDEP}]
	dev-python/soundfile[${PYTHON_USEDEP}]
	dev-python/funasr-onnx[${PYTHON_USEDEP}]
	dev-python/jieba[${PYTHON_USEDEP}]
	ibus? (
		app-i18n/ibus[python,${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	)
	fcitx? (
		app-i18n/fcitx:5
	)
	rime? (
		dev-python/pyrime[${PYTHON_USEDEP}]
		app-i18n/librime
	)
"
DEPEND="
	fcitx? (
		app-i18n/fcitx:5
		dev-cpp/nlohmann_json
	)
"
BDEPEND="
	fcitx? (
		dev-build/cmake
	)
"

src_prepare() {
	default

	# Fix IBus component XML paths for system-wide installation
	if use ibus; then
		sed -i \
			-e "s|VOCOTYPE_EXEC_PATH|/usr/libexec/ibus-engine-vocotype|g" \
			-e "s|VOCOTYPE_VERSION|${PV}|g" \
			data/ibus/vocotype.xml.in || die
	fi
}

src_configure() {
	distutils-r1_src_configure

	if use fcitx; then
		local mycmakeargs=(
			-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
			-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		)
		cmake -S "${S}/fcitx5/addon" -B "${S}/fcitx5/addon/build" \
			"${mycmakeargs[@]}" || die "cmake configure failed"
	fi
}

src_compile() {
	distutils-r1_src_compile

	if use fcitx; then
		cmake --build "${S}/fcitx5/addon/build" -j$(makeopts_jobs) || die "cmake build failed"
	fi
}

src_install() {
	distutils-r1_src_install

	# IBus component
	if use ibus; then
		insinto /usr/share/ibus/component
		newins data/ibus/vocotype.xml.in vocotype.xml

		# IBus engine launcher
		python_scriptinto /usr/libexec
		python_foreach_impl python_newscript ibus/main.py ibus-engine-vocotype
	fi

	# Fcitx5 addon
	if use fcitx; then
		# Install C++ addon shared library
		exeinto "/usr/$(get_libdir)/fcitx5"
		doexe "${S}/fcitx5/addon/build/vocotype.so"

		# Install addon config
		insinto /usr/share/fcitx5/addon
		doins fcitx5/data/vocotype.conf

		# Install input method config
		insinto /usr/share/fcitx5/inputmethod
		newins fcitx5/data/vocotype.conf.in vocotype.conf

		# Install backend script
		python_scriptinto /usr/bin
		python_foreach_impl python_newscript fcitx5/backend/fcitx5_server.py vocotype-fcitx5-backend

		# systemd user service
		if use systemd; then
			systemd_douserunit "${FILESDIR}/vocotype-fcitx5-backend.service"
		fi

		# XDG autostart for non-systemd setups
		insinto /etc/xdg/autostart
		doins "${FILESDIR}/vocotype-fcitx5-backend.desktop"
	fi

	# Model download helper script
	python_scriptinto /usr/bin
	python_foreach_impl python_newscript app/download_models.py vocotype-download-models
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "VoCoType has been installed."
	elog ""
	elog "Before using VoCoType, you need to download the AI models (~500MB):"
	elog "  vocotype-download-models"
	elog ""
	if use ibus; then
		elog "For IBus: restart ibus-daemon and add VoCoType in IBus settings."
		elog "  ibus restart"
		elog ""
	fi
	if use fcitx; then
		elog "For Fcitx5: start the backend service and restart Fcitx5."
		if use systemd; then
			elog "  systemctl --user enable --now vocotype-fcitx5-backend.service"
		fi
		elog "  fcitx5 -r"
		elog ""
	fi
	elog "Usage: Press and hold F9 to speak, release to recognize."
}

pkg_postrm() {
	xdg_icon_cache_update
}
