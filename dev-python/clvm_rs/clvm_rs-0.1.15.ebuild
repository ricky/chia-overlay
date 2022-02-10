# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
autocfg-1.0.1
bitflags-1.3.1
bitvec-0.22.3
block-buffer-0.9.0
bls12_381-0.5.0
bumpalo-3.7.0
byteorder-1.4.3
cc-1.0.69
cfg-if-0.1.10
cfg-if-1.0.0
console_error_panic_hook-0.1.6
cpufeatures-0.1.5
digest-0.9.0
ff-0.10.1
foreign-types-0.3.2
foreign-types-shared-0.1.1
funty-1.2.0
generic-array-0.14.4
group-0.10.0
hex-0.4.3
indoc-0.3.6
indoc-impl-0.3.6
instant-0.1.10
js-sys-0.3.52
lazy_static-1.4.0
libc-0.2.99
lock_api-0.4.4
log-0.4.14
num-bigint-0.4.0
num-integer-0.1.44
num-traits-0.2.14
once_cell-1.8.0
opaque-debug-0.3.0
openssl-0.10.35
openssl-src-111.15.0+1.1.1k
openssl-sys-0.9.65
pairing-0.20.0
parking_lot-0.11.1
parking_lot_core-0.8.3
paste-0.1.18
paste-impl-0.1.18
pkg-config-0.3.19
proc-macro-hack-0.5.19
proc-macro2-1.0.28
pyo3-0.14.2
pyo3-build-config-0.14.2
pyo3-macros-0.14.2
pyo3-macros-backend-0.14.2
quote-1.0.9
radium-0.6.2
rand_core-0.6.3
redox_syscall-0.2.10
scoped-tls-1.0.0
scopeguard-1.1.0
sha2-0.9.5
smallvec-1.6.1
subtle-2.4.1
syn-1.0.74
tap-1.0.1
typenum-1.13.0
unicode-xid-0.2.2
unindent-0.1.7
vcpkg-0.2.15
version_check-0.9.3
wasm-bindgen-0.2.75
wasm-bindgen-backend-0.2.75
wasm-bindgen-futures-0.4.25
wasm-bindgen-macro-0.2.75
wasm-bindgen-macro-support-0.2.75
wasm-bindgen-shared-0.2.75
wasm-bindgen-test-0.3.25
wasm-bindgen-test-macro-0.3.25
web-sys-0.3.52
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wyz-0.4.0
"

PYTHON_COMPAT=( python3_{7..9} )
inherit python-r1 flag-o-matic cargo

DESCRIPTION="Rust implementation of the Chia Lisp Virtual Machine"
HOMEPAGE="https://github.com/Chia-Network/clvm_rs"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Chia-Network/${PN}.git"
	SRC_URI=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64 ~x86"
	SRC_URI="https://github.com/Chia-Network/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
fi

SRC_URI="
	${SRC_URI}
	$(cargo_crate_uris ${CRATES})
"

LICENSE="Apache-2.0 BSD MIT Unlicense"
SLOT="0"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/maturin
	dev-python/wheel
"

S="${WORKDIR}/clvm_rs-${PV}"

src_configure() {
	# Will fail to import without fat-objects.
	# Only really applicable to LTO.
	append-flags "-ffat-lto-objects"

	cargo_src_configure
}

src_install() {
	install_from_wheels() {
		# Create wheel with maturin
		maturin build --release \
			--no-sdist \
			--manylinux "off" \
			--interpreter ${EPYTHON}

		# Unpack wheel
		whl_dir=$(ls "target/wheels/"*whl)
		wheel unpack ${whl_dir}

		# Delete whl
		rm -v ${whl_dir}

		# Install module
		insinto "$(python_get_sitedir)"
		doins -r "clvm_rs-${PV}"/*
	}

	python_foreach_impl install_from_wheels
}
