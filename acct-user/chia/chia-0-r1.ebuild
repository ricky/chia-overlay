# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for chia"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( chia )
ACCT_USER_HOME=/var/lib/chia
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
