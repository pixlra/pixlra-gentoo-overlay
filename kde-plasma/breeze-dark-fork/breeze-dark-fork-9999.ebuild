# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Breeze dark visual style for the Plasma desktop (fork of original breeze icons)"
HOMEPAGE="https://github.com/jfmcarreira/kde-breeze"
KEYWORDS=""

EGIT_REPO_URI="https://github.com/jfmcarreira/kde-breeze.git"
DEPEND="$(add_plasma_dep kbreeze)"
RDEPEND="${DEPEND}"

