# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="https://pypi.org/project/dnspythonchia/"
SRC_URI="https://github.com/Chia-Network/dnspython/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="
	!!dev-python/dnspython
	dev-python/cryptography[${PYTHON_USEDEP}]
	<dev-python/idna-4.0[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_unpack() {
	default_src_unpack
	mv ${WORKDIR}/dnspython-${PV} ${S}
}

src_prepare() {
	sed -i -e '/network_avail/s:True:False:' \
		tests/*.py || die
	distutils-r1_src_prepare

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	epytest -s
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
