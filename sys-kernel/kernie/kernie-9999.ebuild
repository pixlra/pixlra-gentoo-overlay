# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Kernie - Kernel Genie, is a Gentoo kernel manager"
HOMEPAGE="https://github.com/jpataias/kernie"

EGIT_REPO_URI="https://github.com/jpataias/kernie"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	app-shells/bash:0
	dev-util/dialog
	app-admin/eclean-kernel
	app-portage/eix
"
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/sbin/
	doexe ${PN}

	insinto /etc
	doins files/${PN}.conf
}
