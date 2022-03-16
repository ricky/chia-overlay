# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Chia-Network/${PN}.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="Chia Proof of Space"
HOMEPAGE="https://github.com/Chia-Network/chiapos"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

BDEPEND="
	>=dev-python/pybind11-2.5.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-setup.py-git-dirs.patch
)

export CATCH2_SRC_DIR=${WORKDIR}/_deps/Catch2
export CXXOPTS_SRC_DIR=${WORKDIR}/_deps/cxxopts
export GULRAK_SRC_DIR=${WORKDIR}/_deps/gulrak
export PYBIND11_SRC_DIR=${WORKDIR}/_deps/pybind11

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

	mkdir -p ${CXXOPTS_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/jarro2783/cxxopts.git"
	EGIT_OVERRIDE_COMMIT_JARRO2783_CXXOPTS="v2.2.1"
	EGIT_CHECKOUT_DIR=${CXXOPTS_SRC_DIR}
	git-r3_src_unpack

	mkdir -p ${GULRAK_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/gulrak/filesystem.git"
	EGIT_OVERRIDE_COMMIT_GULRAK_FILESYSTEM="v1.5.6"
	EGIT_CHECKOUT_DIR=${GULRAK_SRC_DIR}
	git-r3_src_unpack

	mkdir -p ${PYBIND11_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/pybind/pybind11.git"
	EGIT_OVERRIDE_COMMIT_PYBIND_PYBIND11="v2.7.1"
	EGIT_CHECKOUT_DIR=${PYBIND11_SRC_DIR}
	git-r3_src_unpack
}
