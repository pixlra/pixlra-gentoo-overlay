# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils qmake-utils git-2

DESCRIPTION="A QT5-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"

EGIT_REPO_URI="https://github.com/jfmcarreira/ktikz.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="qt4 qt5 +kde -debug"

REQUIRED_USE="
  ?? ( qt5 qt4 )
  kde? ( qt4 )
"

DEPEND="
  qt5? (
    dev-qt/qtcore:5
    dev-qt/qtgui:5
    dev-qt/qtwidgets:5
    dev-qt/qtprintsupport:5
    app-text/poppler[qt5]
  )
  qt4? (
    dev-qt/qtcore:4
    dev-qt/qtgui:4
    app-text/poppler[qt4]
  )
  kde? (
    kde-base/kdelibs
  )
  virtual/latex-base
  dev-texlive/texlive-latexextra
  dev-tex/pgf
"
RDEPEND="${DEPEND}"

DOCS="Changelog TODO"

S="${WORKDIR}/${PN}"

src_prepare() {
	if ! use kde; then
	    # libs are not equal ldflags, make that sure:
	    sed -i -e 's|QMAKE_LFLAGS|LIBS|' macros.pri || die "sed failed"

# 	    # our lrelease is not versioned
# 	    sed -i -e 's|lrelease-qt4|lrelease|' conf.pri || die "sed failed"
	fi
}

src_configure() {
  if use kde; then
    cmake-utils_src_configure
  else
    KDECONFIG="CONFIG-=usekde"
    if use qt4; then
      eqmake4 qtikz.pro PREFIX="${D}/usr" "CONFIG+=nostrip" "$KDECONFIG"
    else
      eqmake5 qtikz.pro PREFIX="${D}/usr" "CONFIG+=nostrip" "$KDECONFIG"
    fi
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
      emake INSTALL_ROOT="${D}" install
    fi
}

