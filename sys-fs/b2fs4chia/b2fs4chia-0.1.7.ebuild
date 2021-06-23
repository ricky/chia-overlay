# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Backblaze-B2-Samples/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/Backblaze-B2-Samples/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
fi

DESCRIPTION="FUSE integration for Backblaze B2 Cloud storage"
HOMEPAGE="https://github.com/Backblaze-B2-Samples/b2fs4chia"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/b2sdk[${PYTHON_USEDEP}]
	dev-python/intervaltree[${PYTHON_USEDEP}]
	dev-python/fusepy[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
