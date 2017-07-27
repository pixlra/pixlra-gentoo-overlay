# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils qmake-utils git-r3

DESCRIPTION="A QT5-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"

EGIT_REPO_URI="https://github.com/jfmcarreira/ktikz.git"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS=""
IUSE="+kde -debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qthelp:4
	app-text/poppler[qt4]
	kde? (
		kde-frameworks/kdelibs
	)
	virtual/latex-base
	dev-texlive/texlive-latexextra
	dev-tex/pgf
"
RDEPEND="${DEPEND}"

DOCS="Changelog TODO"

S="${WORKDIR}/${PN}"

src_configure() {
	if use kde; then
		cmake-utils_src_configure
	else
		KDECONFIG="CONFIG-=usekde"
		eqmake4 qtikz.pro "CONFIG+=nostrip" "$KDECONFIG"
	fi
}

src_compile() {
		if use kde; then
			cmake-utils_src_compile
		else
			default
		fi
}

src_install() {
		if use kde; then
			cmake-utils_src_install
		else
			emake INSTALL_ROOT="${D}" PREFIX="${EPREFIX}/usr" install
		fi
}
