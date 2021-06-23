# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="B2 Python SDK"
HOMEPAGE="https://github.com/Backblaze/b2-sdk-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

RDEPEND="
	dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/logfury[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	eapply_user

	# unpin deps
	sed -i -r 's/setuptools_scm<6.0/setuptools_scm/' setup.py || die
	sed -i -r 's/"(.*)==.*"/"\1"/g' requirements.txt || die
	distutils-r1_src_prepare
}
