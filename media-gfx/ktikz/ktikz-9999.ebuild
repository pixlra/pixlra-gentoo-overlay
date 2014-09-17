# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils git-2

DESCRIPTION="A QT5-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"

EGIT_REPO_URI="https://github.com/jfmcarreira/ktikz.git"
# EGIT_COMMIT="${PV}"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS=""
IUSE="+kde -debug"

#DEPEND="x11-libs/qt-gui:4
DEPEND="
    dev-qt/qtgui:5
    dev-qt/qtwidgets:5
    dev-qt/qthelp:5
    app-text/poppler[qt5]
    virtual/latex-base
    dev-texlive/texlive-latexextra
    dev-tex/pgf
"
	
RDEPEND="${DEPEND}"

DOCS="Changelog TODO"

S="${WORKDIR}/${PN}"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if ! use kde; then
	    # libs are not equal ldflags, make that sure:
	    sed -i -e 's|QMAKE_LFLAGS|LIBS|' macros.pri || die "sed failed"

	    # our lrelease is not versioned
	    sed -i -e 's|lrelease-qt4|lrelease|' conf.pri || die "sed failed"
	fi
}

src_configure() {
# 	if use kde; then
	    local mycmakeargs=( -DCMAKE_INSTALL_PREFIX=`kde5-config --prefix` )
	    cmake-utils_src_configure
#   else
# 	    KDECONFIG="CONFIG-=usekde"
# 	    eqmake5 qtikz.pro PREFIX="${D}/usr" "CONFIG+=nostrip" "$KDECONFIG"
# 	fi
}

src_compile() {
# 	if use kde; then
	    cmake-utils_src_compile
# 	else
# 	    qt5_src_compile
# 	fi
}

src_install() {
# 	if use kde; then
	    cmake-utils_src_install
# 	else
# 	    qt5_src_install
# 	fi
}
