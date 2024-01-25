# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for akkoma"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( akkoma )

ACCT_USER_HOME=/var/lib/akkoma

acct-user_add_deps
