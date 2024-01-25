# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Package manager for the Erlang VM"
HOMEPAGE="https://hex.pm/"

SRC_URI="https://github.com/hexpm/hex/archive/refs/tags/v2.0.6.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-lang/elixir
"

RDEPEND="${DEPEND}"

src_compile() {
	MIX_ENV=prod mix compile
}

src_install() {
	local dest="/usr/$(get_libdir)/erlang/lib/${P}"

	insinto "${dest}"
	doins -r "_build/prod/lib/${PN}/ebin"
}
