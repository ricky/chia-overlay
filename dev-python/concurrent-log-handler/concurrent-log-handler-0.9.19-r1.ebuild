# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="RotatingFileHandler replacement with concurrency, gzip and Windows support"
HOMEPAGE="https://github.com/Preston-Landers/concurrent-log-handler"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-python/portalocker[${PYTHON_USEDEP}]
"
