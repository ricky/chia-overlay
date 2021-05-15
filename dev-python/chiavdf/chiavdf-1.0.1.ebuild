# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 git-r3

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Chia-Network/${PN}.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="Chia vdf verification"
HOMEPAGE="https://github.com/Chia-Network/chiavdf"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

BDEPEND="
	dev-libs/gmp
	>=dev-python/pybind11-2.5.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-setup.py-git-dirs.patch
)

export CMAKE_LIBRARY_ARCHITECTURE=${CTARGET:-${CHOST}}
export PYBIND11_SRC_DIR=${WORKDIR}/_deps/pybind11

src_unpack() {
	default_src_unpack

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi

	mkdir -p ${PYBIND11_SRC_DIR} || die
	EGIT_REPO_URI="https://github.com/pybind/pybind11.git"
	EGIT_TAG="v2.6.2"
	EGIT_CHECKOUT_DIR=${PYBIND11_SRC_DIR}
	git-r3_src_unpack
}
