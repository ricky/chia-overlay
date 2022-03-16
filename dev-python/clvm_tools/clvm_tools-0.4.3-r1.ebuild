# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Chia-Network/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/Chia-Network/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
fi

DESCRIPTION="Chia Lisp Virtual Machine tools"
HOMEPAGE="https://github.com/Chia-Network/clvm_tools"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=">=dev-python/clvm-0.9.2[${PYTHON_USEDEP}]"
