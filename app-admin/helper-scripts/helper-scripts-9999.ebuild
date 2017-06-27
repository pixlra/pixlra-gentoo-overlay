# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 bash-completion-r1

DESCRIPTION="Helper scripts for managing linux systems"
HOMEPAGE="https://github.com/jfmcarreira/dotfiles.git"
LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/jfmcarreira/dotfiles.git"

SLOT=0
KEYWORDS="~amd64"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin scripts/.bin/update-kernel
	dobashcomp scripts/.bash_completion.d/update-kernel
}
