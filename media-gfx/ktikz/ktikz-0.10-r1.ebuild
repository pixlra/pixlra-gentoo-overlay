# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils qt4-r2 cmake-utils

MY_P="${PN}_${PV}"

DESCRIPTION="A QT4-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"
SRC_URI="http://www.hackenberger.at/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde debug"

#DEPEND="x11-libs/qt-gui:4
DEPEND="dev-qt/qtgui:4
	dev-qt/qthelp:4
	app-text/poppler[qt4]
	virtual/latex-base
	dev-texlive/texlive-latexextra
	dev-tex/pgf"
RDEPEND="${DEPEND}"

DOCS="Changelog TODO"

S="${WORKDIR}/${PN}"

src_prepare() {
	
	# patch some diffs
	epatch "${FILESDIR}/${PN}-${PV}-currenthighlight.patch"
	
	# libs are not equal ldflags, make that sure:
	sed -i -e 's|QMAKE_LFLAGS|LIBS|' macros.pri || die "sed failed"

	# our lrelease is not versioned
	sed -i -e 's|lrelease-qt4|lrelease|' conf.pri || die "sed failed"
}

src_configure() {
	if use kde; then
	    local mycmakeargs=( -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` )
	    cmake-utils_src_configure
	else
	    KDECONFIG="CONFIG-=usekde"
	    eqmake4 qtikz.pro PREFIX="${D}/usr" "CONFIG+=nostrip" "$KDECONFIG"
	fi
}

src_compile() {
	if use kde; then
	    cmake-utils_src_compile
	else
	    qt4-r2_src_compile
	fi
}

src_install() {
	if use kde; then
	    cmake-utils_src_install
	else
	    qt4-r2_src_install
	fi
	
}