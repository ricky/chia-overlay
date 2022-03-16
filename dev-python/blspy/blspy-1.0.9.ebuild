# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

DESCRIPTION="BLS Signatures implementation"
HOMEPAGE="https://github.com/Chia-Network/bls-signatures"

if [[ ${PV} == 9999 ]]; then
		EGIT_REPO_URI="https://github.com/Chia-Network/bls-signatures.git"
else
		SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
		KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

BDEPEND="
	>=dev-python/pybind11-2.5.0[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-libs/gmp[static-libs]
	dev-libs/libsodium[static-libs]
"

PATCHES=(
	"${FILESDIR}"/${PN}-setup.py-git-dirs.patch
)

export CMAKE_LIBRARY_ARCHITECTURE=${CTARGET:-${CHOST}}
export CATCH2_SRC_DIR=${WORKDIR}/_deps/Catch2
export SODIUM_SRC_DIR=${WORKDIR}/_deps/libsodium-cmake
export PYBIND11_SRC_DIR=${WORKDIR}/_deps/pybind11
export RELIC_SRC_DIR=${WORKDIR}/_deps/relic-src

src_unpack() {
	default_src_unpack

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi

	mkdir -p ${CATCH2_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/catchorg/Catch2.git"
	EGIT_OVERRIDE_COMMIT_CATCHORG_CATCH2="v2.13.7"
	EGIT_CHECKOUT_DIR=${CATCH2_SRC_DIR}
	git-r3_src_unpack

	mkdir -p ${SODIUM_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/AmineKhaldi/libsodium-cmake.git"
	EGIT_OVERRIDE_COMMIT_AMINEKHALDI_LIBSODIUM_CMAKE="f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"
	EGIT_CHECKOUT_DIR=${SODIUM_SRC_DIR}
	git-r3_src_unpack

	mkdir -p ${PYBIND11_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/pybind/pybind11.git"
	EGIT_OVERRIDE_COMMIT_PYBIND_PYBIND11="v2.6.2"
	EGIT_CHECKOUT_DIR=${PYBIND11_SRC_DIR}
	git-r3_src_unpack

	mkdir -p ${RELIC_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/Chia-Network/relic.git"
	EGIT_OVERRIDE_BRANCH_CHIA_NETWORK_RELIC="aecdcae_local_cflags"
	EGIT_OVERRIDE_COMMIT_CHIA_NETWORK_RELIC="1d98e5abf3ca5b14fd729bd5bcced88ea70ecfd7"
	EGIT_CHECKOUT_DIR=${RELIC_SRC_DIR}
	git-r3_src_unpack
}
