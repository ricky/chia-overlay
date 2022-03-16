# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Simple library to encode/decode DNS wire-format packets"
HOMEPAGE="https://github.com/paulc/dnslib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""
