# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pipelined, multi-threaded Chia plotter"
HOMEPAGE="https://github.com/madMAx43v3r/chia-plotter"

LICENSE="GPL-3"
SLOT="0"

EGIT_REPO_URI="https://github.com/madMAx43v3r/${PN}.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_TAG="${PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

inherit cmake git-r3

RDEPEND="
	dev-libs/gmp[static-libs]
	dev-libs/libsodium[static-libs]
"

CMAKE_MAKEFILE_GENERATOR="emake"
PYBIND_DIR=${BUILD_DIR}/_deps/pybind11
RELIC_DIR=${BUILD_DIR}/_deps/relic-src

src_unpack() {
	default_src_unpack
	git-r3_src_unpack

	mkdir -p ${PYBIND_DIR} || die
	EGIT_REPO_URI="https://github.com/pybind/pybind11.git"
	EGIT_TAG="v2.6.2"
	EGIT_CHECKOUT_DIR=${PYBIND_DIR}
	git-r3_src_unpack

	mkdir -p ${RELIC_DIR} || die
	EGIT_REPO_URI="https://github.com/relic-toolkit/relic.git"
	EGIT_COMMIT="1885ae3b681c423c72b65ce1fe70910142cf941c"
	EGIT_CHECKOUT_DIR=${RELIC_DIR}
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_BLS_BENCHMARKS=false
		-DBUILD_BLS_PYTHON_BINDINGS=false
		-DBUILD_BLS_TESTS=false
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_LIBRARY_ARCHITECTURE=${CTARGET:-${CHOST}}
		-DFETCHCONTENT_SOURCE_DIR_RELIC=${RELIC_DIR}
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/chia_plot"
	dodoc "${S}/README.md"
}
