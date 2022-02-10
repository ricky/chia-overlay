# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Chia-Network/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Chia blockchain python implementation"
HOMEPAGE="https://chia.net/"

LICENSE="Apache-2.0"
SLOT="0"

IUSE="systemd upnp"

RDEPEND="
	acct-group/chia
	acct-user/chia
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/aiosqlite[${PYTHON_USEDEP}]
	dev-python/bitstring[${PYTHON_USEDEP}]
	dev-python/blspy[${PYTHON_USEDEP}]
	dev-python/chiabip158[${PYTHON_USEDEP}]
	dev-python/chiapos[${PYTHON_USEDEP}]
	dev-python/chiavdf[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/clvm[${PYTHON_USEDEP}]
	dev-python/clvm_rs[${PYTHON_USEDEP}]
	dev-python/clvm_tools[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/concurrent-log-handler[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/keyrings-cryptfile[${PYTHON_USEDEP}]
	dev-python/multidict[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	dev-python/watchdog[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	systemd? ( sys-apps/systemd )
	upnp? ( >=dev-python/miniupnpc-2.2[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-dnspython.patch
)

distutils_enable_tests pytest

src_prepare() {
	eapply_user

	# unpin deps
	sed -i -e "s:>=.*':':" setup.py || die
	sed -i -r 's/"(.*)==.*"/"\1"/g' setup.py || die
	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	if use systemd ; then
		systemd_newuserunit "${FILESDIR}/chia.service" "chia@.service"
	else
		newinitd "${FILESDIR}"/chia.initd chia
	fi

	newconfd "${FILESDIR}"/chia.confd chia
}

pkg_postinst() {
	elog "Before running the service(s), initialize the chia configuration by running"
	elog "the 'chia init' command as the user who will run the service. If you have not"
	elog "yet created keys, you should also run 'chia keys generate'."
	elog

	if use systemd; then
		elog "The chia service can be run by any user. To start the service run:"
		elog
		elog "$ systemctl --user start chia@<SERVICE>"
		elog
		elog "Where <SERVICE> is one of:"
		elog "  all,node,harvester,farmer,farmer-no-wallet,farmer-only,timelord,timelord-only,"
		elog "  timelord-launcher-only,wallet,wallet-only,introducer,simulator"
	else
		elog "Start the chia services with '/etc/init.d/chia start'."
		elog
		elog "You can configure which service(s) to run and which user to run as"
		elog "in '/etc/conf.d/chia'. By default, it runs the farmer services a the 'chia' user."
	fi
}
