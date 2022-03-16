# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Encrypted file keyring backend"
HOMEPAGE="https://github.com/frispete/keyrings.cryptfile"
SRC_URI="mirror://pypi/k/keyrings.cryptfile/keyrings.cryptfile-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	>=dev-python/keyring-19.0.0[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]"

S="${WORKDIR}/keyrings.cryptfile-${PV}"
