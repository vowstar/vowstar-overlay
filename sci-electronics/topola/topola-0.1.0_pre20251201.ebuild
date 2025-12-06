# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ab_glyph@0.2.32
	ab_glyph_rasterizer@0.1.10
	accesskit@0.17.1
	accesskit_atspi_common@0.10.1
	accesskit_consumer@0.26.0
	accesskit_macos@0.18.1
	accesskit_unix@0.13.1
	accesskit_windows@0.24.1
	accesskit_winit@0.23.1
	adler2@2.0.1
	ahash@0.8.12
	aho-corasick@1.1.4
	allocator-api2@0.2.21
	android-activity@0.6.0
	android-properties@0.2.2
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	approx@0.5.1
	arboard@3.6.1
	arrayvec@0.7.6
	as-raw-xcb-connection@1.0.1
	as-slice@0.1.5
	ash@0.38.0+1.3.281
	ashpd@0.11.0
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.13.3
	async-fs@2.2.0
	async-io@2.6.0
	async-lock@3.4.1
	async-net@2.0.0
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.13
	async-task@4.7.1
	async-trait@0.1.89
	atk-sys@0.18.2
	atomic-polyfill@1.0.3
	atomic-waker@1.1.2
	atspi-common@0.6.0
	atspi-connection@0.6.0
	atspi-proxies@0.6.0
	atspi@0.22.0
	autocfg@1.5.0
	base64@0.21.7
	base64@0.22.1
	bimap@0.6.3
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@1.3.2
	bitflags@2.10.0
	block-buffer@0.10.4
	block2@0.5.1
	block2@0.6.2
	block@0.1.6
	blocking@1.6.2
	bstr@1.12.1
	bumpalo@3.19.0
	bytemuck@1.24.0
	bytemuck_derive@1.10.2
	byteorder-lite@0.1.0
	byteorder@1.5.0
	bytes@1.11.0
	cairo-sys-rs@0.18.2
	calloop-wayland-source@0.3.0
	calloop-wayland-source@0.4.1
	calloop@0.13.0
	calloop@0.14.3
	cc@1.2.48
	cesu8@1.1.0
	cfg-expr@0.15.8
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	cgl@0.3.2
	clap@4.5.53
	clap_builder@4.5.53
	clap_derive@4.5.49
	clap_lex@0.7.6
	clap_mangen@0.2.31
	clipboard-win@5.4.1
	codespan-reporting@0.11.1
	colorchoice@1.0.4
	combine@4.6.7
	concurrent-queue@2.5.0
	console@0.15.11
	contracts-try@0.7.0
	core-foundation-sys@0.8.7
	core-foundation@0.10.1
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	core-graphics@0.23.2
	cpufeatures@0.2.17
	crc32fast@1.5.0
	critical-section@1.2.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	crypto-common@0.1.7
	cursor-icon@1.2.0
	derive-getters@0.5.0
	digest@0.10.7
	dispatch2@0.3.0
	dispatch@0.2.0
	displaydoc@0.2.5
	dlib@0.5.2
	document-features@0.2.12
	downcast-rs@1.2.1
	dpi@0.1.2
	ecolor@0.31.1
	eframe@0.31.1
	egui-wgpu@0.31.1
	egui-winit@0.31.1
	egui@0.31.1
	egui_glow@0.31.1
	either@1.15.0
	emath@0.31.1
	encode_unicode@1.0.0
	endi@1.1.1
	enum_dispatch@0.3.13
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	enumn@0.1.14
	env_filter@0.1.4
	env_logger@0.11.8
	epaint@0.31.1
	epaint_default_fonts@0.31.1
	equivalent@1.0.2
	errno@0.3.14
	error-code@3.3.2
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	fastrand@2.3.0
	fax@0.2.6
	fax_derive@0.2.0
	fdeflate@0.3.7
	find-msvc-tools@0.1.5
	fixed_decimal@0.7.1
	fixedbitset@0.4.2
	flate2@1.1.7
	float_next_after@1.0.0
	fluent-bundle@0.16.0
	fluent-langneg@0.13.1
	fluent-syntax@0.12.0
	fluent-template-macros@0.13.2
	fluent-templates@0.13.2
	flume@0.11.1
	fnv@1.0.7
	foldhash@0.1.5
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	form_urlencoded@1.2.2
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-io@0.3.31
	futures-lite@2.6.1
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-timer@3.0.3
	futures-util@0.3.31
	gdk-pixbuf-sys@0.18.0
	gdk-sys@0.18.2
	generic-array@0.12.4
	generic-array@0.13.3
	generic-array@0.14.7
	geo-types@0.7.18
	geo@0.29.3
	geographiclib-rs@0.2.5
	gethostname@1.1.0
	getrandom@0.2.16
	getrandom@0.3.4
	gio-sys@0.18.1
	gl_generator@0.14.0
	glib-sys@0.18.1
	glob@0.3.3
	globset@0.4.18
	glow@0.16.0
	glutin-winit@0.5.0
	glutin@0.32.3
	glutin_egl_sys@0.7.1
	glutin_glx_sys@0.6.1
	glutin_wgl_sys@0.6.1
	gobject-sys@0.18.0
	gpu-alloc-types@0.3.0
	gpu-alloc@0.6.0
	gpu-descriptor-types@0.2.0
	gpu-descriptor@0.3.2
	gtk-sys@0.18.2
	half@2.7.1
	hash32@0.1.1
	hash32@0.2.1
	hash32@0.3.1
	hashbrown@0.15.5
	hashbrown@0.16.1
	heapless@0.6.1
	heapless@0.7.17
	heapless@0.8.0
	heck@0.5.0
	hermit-abi@0.5.2
	hex@0.4.3
	hexf-parse@0.2.1
	home@0.5.12
	i_float@1.6.0
	i_key_sort@0.2.0
	i_overlay@1.9.4
	i_shape@1.6.0
	i_tree@0.8.3
	icu_casemap@2.0.1
	icu_casemap_data@2.0.0
	icu_collections@2.0.0
	icu_decimal@2.0.1
	icu_decimal_data@2.0.0
	icu_experimental@0.3.1
	icu_experimental_data@0.3.0
	icu_list@2.0.1
	icu_list_data@2.0.0
	icu_locale@2.0.0
	icu_locale_core@2.1.1
	icu_locale_data@2.0.0
	icu_normalizer@2.0.1
	icu_normalizer_data@2.0.0
	icu_pattern@0.4.1
	icu_plurals@2.0.0
	icu_plurals_data@2.0.0
	icu_properties@2.0.2
	icu_properties_data@2.0.1
	icu_provider@2.1.1
	idna@1.1.0
	idna_adapter@1.2.1
	ignore@0.4.25
	image@0.25.9
	immutable-chunkmap@2.1.2
	indexmap@2.12.1
	intl-memoizer@0.5.3
	intl_pluralrules@7.0.2
	is_terminal_polyfill@1.70.2
	itertools@0.14.0
	itoa@1.0.15
	jiff-static@0.2.16
	jiff@0.2.16
	jni-sys@0.3.0
	jni@0.21.1
	jobserver@0.1.34
	js-sys@0.3.83
	khronos-egl@6.0.0
	khronos_api@3.1.0
	libc@0.2.178
	libloading@0.8.9
	libm@0.2.15
	libredox@0.1.10
	linux-raw-sys@0.11.0
	linux-raw-sys@0.4.15
	litemap@0.8.1
	litrs@1.0.0
	lock_api@0.4.14
	log@0.4.29
	malloc_buf@0.0.6
	memchr@2.7.6
	memmap2@0.9.9
	memoffset@0.9.1
	metal@0.31.0
	miniz_oxide@0.8.9
	moxcms@0.7.10
	naga@24.0.0
	ndk-context@0.1.1
	ndk-sys@0.5.0+25.2.9519653
	ndk-sys@0.6.0+11769913
	ndk@0.9.0
	nix@0.29.0
	nix@0.30.1
	nohash-hasher@0.2.0
	num-bigint@0.4.6
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	num_enum@0.7.5
	num_enum_derive@0.7.5
	objc-sys@0.3.5
	objc2-app-kit@0.2.2
	objc2-app-kit@0.3.2
	objc2-cloud-kit@0.2.2
	objc2-contacts@0.2.2
	objc2-core-data@0.2.2
	objc2-core-foundation@0.3.2
	objc2-core-graphics@0.3.2
	objc2-core-image@0.2.2
	objc2-core-location@0.2.2
	objc2-encode@4.1.0
	objc2-foundation@0.2.2
	objc2-foundation@0.3.2
	objc2-io-surface@0.3.2
	objc2-link-presentation@0.2.2
	objc2-metal@0.2.2
	objc2-quartz-core@0.2.2
	objc2-symbols@0.2.2
	objc2-ui-kit@0.2.2
	objc2-uniform-type-identifiers@0.2.2
	objc2-user-notifications@0.2.2
	objc2@0.5.2
	objc2@0.6.3
	objc@0.2.7
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	orbclient@0.3.49
	ordered-float@4.6.0
	ordered-stream@0.2.0
	owned_ttf_parser@0.25.1
	pango-sys@0.18.0
	parking@2.2.1
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	pdqselect@0.1.0
	peeking_take_while@1.0.0
	percent-encoding@2.3.2
	pin-project-internal@1.1.10
	pin-project-lite@0.2.16
	pin-project@1.1.10
	pin-utils@0.1.0
	piper@0.2.4
	pkg-config@0.3.32
	png@0.18.0
	polling@3.11.0
	pollster@0.4.0
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	potential_utf@0.1.4
	ppv-lite86@0.2.21
	proc-macro-crate@3.4.0
	proc-macro-hack@0.5.20+deprecated
	proc-macro2@1.0.103
	profiling@1.0.17
	pxfm@0.1.26
	quick-error@1.2.3
	quick-error@2.0.1
	quick-xml@0.30.0
	quick-xml@0.37.5
	quote@1.0.42
	r-efi@5.3.0
	rand@0.8.5
	rand@0.9.2
	rand_chacha@0.3.1
	rand_chacha@0.9.0
	rand_core@0.6.4
	rand_core@0.9.3
	raw-window-handle@0.6.2
	redox_syscall@0.4.1
	redox_syscall@0.5.18
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	relative-path@1.9.3
	renderdoc-sys@1.1.0
	rfd@0.15.4
	robust@1.2.0
	roff@0.2.2
	ron@0.10.1
	ron@0.8.1
	rstar@0.10.0
	rstar@0.11.0
	rstar@0.12.2
	rstar@0.8.4
	rstar@0.9.3
	rustc-hash@1.1.0
	rustc-hash@2.1.1
	rustc_version@0.4.1
	rustix@0.38.44
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	self_cell@1.2.1
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_repr@0.1.20
	serde_spanned@0.6.9
	sha1@0.10.6
	shlex@1.3.0
	signal-hook-registry@1.4.7
	simd-adler32@0.3.7
	similar@2.7.0
	slab@0.4.11
	slotmap@1.0.7
	smallvec@1.15.1
	smithay-client-toolkit@0.19.2
	smithay-client-toolkit@0.20.0
	smithay-clipboard@0.7.3
	smol_str@0.2.2
	spade@2.15.0
	spin@0.9.8
	spirv@0.3.0+sdk-1.3.268.0
	stable_deref_trait@1.2.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.111
	synstructure@0.13.2
	sys-locale@0.3.2
	system-deps@6.2.2
	target-lexicon@0.12.16
	tempfile@3.23.0
	termcolor@1.4.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.17
	thiserror@1.0.69
	thiserror@2.0.17
	tiff@0.10.3
	tinystr@0.8.2
	toml@0.8.23
	toml_datetime@0.6.11
	toml_datetime@0.7.3
	toml_edit@0.22.27
	toml_edit@0.23.7
	toml_parser@1.0.4
	tracing-attributes@0.1.31
	tracing-core@0.1.35
	tracing@0.1.43
	ttf-parser@0.25.1
	type-map@0.5.1
	typenum@1.19.0
	uds_windows@1.1.0
	unarray@0.1.4
	unic-langid-impl@0.9.6
	unic-langid-macros-impl@0.9.6
	unic-langid-macros@0.9.6
	unic-langid@0.9.6
	unicode-ident@1.0.22
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-xid@0.2.6
	url@2.5.7
	urlencoding@2.1.3
	utf8-chars@3.0.6
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.19.0
	version-compare@0.2.1
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-futures@0.4.56
	wasm-bindgen-macro-support@0.2.106
	wasm-bindgen-macro@0.2.106
	wasm-bindgen-shared@0.2.106
	wasm-bindgen@0.2.106
	wayland-backend@0.3.11
	wayland-client@0.31.11
	wayland-csd-frame@0.3.0
	wayland-cursor@0.31.11
	wayland-protocols-experimental@20250721.0.1
	wayland-protocols-misc@0.3.9
	wayland-protocols-plasma@0.3.9
	wayland-protocols-wlr@0.3.9
	wayland-protocols@0.32.9
	wayland-scanner@0.31.7
	wayland-sys@0.31.7
	web-sys@0.3.83
	web-time@1.1.0
	webbrowser@1.0.6
	weezl@0.1.12
	wgpu-core@24.0.5
	wgpu-hal@24.0.4
	wgpu-types@24.0.0
	wgpu@24.0.5
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.58.0
	windows-implement@0.58.0
	windows-interface@0.58.0
	windows-link@0.2.1
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows@0.58.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winit@0.30.12
	winnow@0.7.14
	wit-bindgen@0.46.0
	writeable@0.6.2
	x11-dl@2.21.0
	x11rb-protocol@0.13.2
	x11rb@0.13.2
	xcursor@0.3.10
	xdg-home@1.3.0
	xkbcommon-dl@0.4.2
	xkeysym@0.2.1
	xml-rs@0.8.28
	yoke-derive@0.8.1
	yoke@0.8.1
	zbus-lockstep-macros@0.4.4
	zbus-lockstep@0.4.4
	zbus@4.4.0
	zbus@5.12.0
	zbus_macros@4.4.0
	zbus_macros@5.12.0
	zbus_names@3.0.0
	zbus_names@4.2.0
	zbus_xml@4.0.0
	zerocopy-derive@0.8.31
	zerocopy@0.8.31
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
	zune-core@0.4.12
	zune-jpeg@0.4.21
	zvariant@4.2.0
	zvariant@5.8.0
	zvariant_derive@4.2.0
	zvariant_derive@5.8.0
	zvariant_utils@2.1.0
	zvariant_utils@3.2.1
"

PYTHON_COMPAT=( python3_{11..13} )

# Topola uses a fork of petgraph from codeberg
PETGRAPH_COMMIT="1bae625ec5f0373ebe859e027af56dcb11a3ac85"
TOPOLA_COMMIT="3b56eb74c973b148350fc1b0ebcb2040548cbdbc"

inherit cargo desktop python-any-r1

DESCRIPTION="Work-in-progress topological (rubberband) router and autorouter for PCBs"
HOMEPAGE="https://topola.dev https://codeberg.org/topola/topola"
SRC_URI="
	https://codeberg.org/topola/topola/archive/${TOPOLA_COMMIT}.tar.gz
		-> ${P}.tar.gz
	https://codeberg.org/topola/petgraph/archive/${PETGRAPH_COMMIT}.tar.gz
		-> ${PN}-petgraph-${PETGRAPH_COMMIT}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/topola"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 CC0-1.0 ISC MIT
	MPL-2.0 OFL-1.1 UbuntuFontLicense-1.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk3 wayland X"

RDEPEND="
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/libglvnd
	x11-libs/libxkbcommon[wayland?,X?]
	gtk3? ( x11-libs/gtk+:3 )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXrandr
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/topola"

pkg_setup() {
	python-any-r1_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	# Move petgraph fork to expected location
	mv "${WORKDIR}/petgraph" "${WORKDIR}/petgraph-topola" || die

	# Patch Cargo.toml to use local petgraph instead of git
	sed -i \
		-e 's|git = "https://codeberg.org/topola/petgraph.git"|path = "../petgraph-topola"|' \
		Cargo.toml || die

	# Remove fuzz workspace members (not needed for release build)
	sed -i \
		-e 's|members = \[".", "crates/\*", "crates/\*/fuzz"\]|members = [".", "crates/*"]|' \
		Cargo.toml || die

	# Remove dev-dependencies that require network access
	# Use Python for reliable removal of [dev-dependencies] and [dev-dependencies.xxx] sections
	python3 - << 'PYEOF' || die "Failed to remove dev-dependencies"
import os
import re

def remove_dev_deps(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()
    result = []
    skip = False
    for line in lines:
        if re.match(r'^\[dev-dependencies', line):
            skip = True
            continue
        if line.startswith('[') and not re.match(r'^\[dev-dependencies', line):
            skip = False
        if not skip:
            result.append(line)
    with open(filepath, 'w') as f:
        f.writelines(result)

for root, dirs, files in os.walk('.'):
    if 'fuzz' in root:
        continue
    for f in files:
        if f == 'Cargo.toml':
            remove_dev_deps(os.path.join(root, f))
PYEOF

	cargo_src_prepare
}

src_configure() {
	local myfeatures=(
		$(usev gtk3)
		$(usex wayland xdg-portal '')
	)
	cargo_src_configure --package topola-egui
}

src_compile() {
	cargo_src_compile --package topola-egui
}

src_install() {
	dobin target/release/topola-egui
	dosym topola-egui /usr/bin/topola

	# Install icon and create desktop entry
	doicon -s scalable assets/logos/topola/icon.svg
	make_desktop_entry topola Topola icon \
		"Electronics;Engineering" \
		"MimeType=application/x-kicad-pcb;"

	dodoc README.md CONTRIBUTING.md INSTALL.md

	einstalldocs
}
