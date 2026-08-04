# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"
PYTHON_COMPAT=( python3_{12..15} )

CRATES="
	allocator-api2@0.2.21
	android_system_properties@0.1.5
	anyhow@1.0.102
	autocfg@1.5.0
	bitflags@2.11.0
	bumpalo@3.20.2
	cassowary@0.3.0
	castaway@0.2.4
	cc@1.2.58
	cfg-if@1.0.4
	chrono@0.4.44
	compact_str@0.8.1
	core-foundation-sys@0.8.7
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crossterm@0.28.1
	crossterm_winapi@0.9.1
	darling@0.23.0
	darling_core@0.23.0
	darling_macro@0.23.0
	dirs-sys@0.5.0
	dirs@6.0.0
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.3.0
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	getrandom@0.2.17
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	id-arena@2.3.0
	ident_case@1.0.1
	indexmap@2.13.0
	indoc@2.0.7
	instability@0.3.12
	itertools@0.13.0
	itoa@1.0.18
	js-sys@0.3.92
	leb128fmt@0.1.0
	libc@0.2.183
	libredox@0.1.15
	linux-raw-sys@0.12.1
	linux-raw-sys@0.4.15
	lock_api@0.4.14
	log@0.4.29
	lru@0.12.5
	memchr@2.8.0
	mio@1.2.0
	ntapi@0.4.3
	num-traits@0.2.19
	once_cell@1.21.4
	option-ext@0.2.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	prettyplease@0.2.37
	proc-macro2@1.0.106
	proc_pidinfo@0.1.4
	quote@1.0.45
	r-efi@6.0.0
	ratatui@0.29.0
	rayon-core@1.13.0
	rayon@1.12.0
	redox_syscall@0.5.18
	redox_users@0.5.2
	rustix@0.38.44
	rustix@1.1.4
	rustversion@1.0.22
	ryu@1.0.23
	scopeguard@1.2.0
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	shlex@1.3.0
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	smallvec@1.15.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.117
	sysinfo@0.32.1
	tempfile@3.27.0
	thiserror-impl@2.0.18
	thiserror@2.0.18
	unicode-ident@1.0.24
	unicode-segmentation@1.13.2
	unicode-truncate@1.1.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	unicode-xid@0.2.6
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.115
	wasm-bindgen-macro@0.2.115
	wasm-bindgen-shared@0.2.115
	wasm-bindgen@0.2.115
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.57.0
	windows-core@0.62.2
	windows-implement@0.57.0
	windows-implement@0.60.2
	windows-interface@0.57.0
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.1.2
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.59.0
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows@0.57.0
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	zmij@1.0.21
"

inherit cargo python-single-r1

DESCRIPTION="Terminal monitor for coding agent sessions"
HOMEPAGE="https://github.com/graykode/abtop"
SRC_URI="
	https://github.com/graykode/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	MIT MPL-2.0 Unicode-3.0 ZLIB
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-vcs/git
	net-misc/curl
	sys-process/procps
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

PATCHES=( "${FILESDIR}"/${P}-hardening.patch )

pkg_setup() {
	python-single-r1_pkg_setup
	rust_pkg_setup
}

src_install() {
	cargo_src_install

	local DOCS=( README.md )
	einstalldocs
}
