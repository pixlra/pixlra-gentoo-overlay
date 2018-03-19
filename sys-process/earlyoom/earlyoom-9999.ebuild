# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Early out-of-memory killer that runs in user-space"
HOMEPAGE="https://github.com/rfjakob/earlyoom"

EGIT_REPO_URI="https://github.com/rfjakob/earlyoom.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DISTDDIR=$WORKDIR

src_install() {
	dobin earlyoom
	doinitd "${FILESDIR}/earlyoom"
}
