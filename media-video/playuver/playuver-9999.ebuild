# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="plaYUVer is an open-source QT based raw video player"
HOMEPAGE="https://github.com/pixlra/playuver"
LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/pixlra/playuver.git"

SLOT=0
KEYWORDS=""

X86_CPU_FEATURES="cpu_flags_x86_sse"
IUSE="+qt5 -qt4 ffmpeg opencv -static-libs $X86_CPU_FEATURES"

DEPEND="
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
	qt4? (
		dev-qt/qtdbus:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	ffmpeg? ( virtual/ffmpeg )
	opencv? ( media-libs/opencv )
"

RDEPEND="${DEPEND}"

REQUIRED_USE="
	?? ( qt5 qt4 )
	qt4? ( !opencv )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use cpu_flags_x86_sse SSE) # use SSE
		$(cmake-utils_use_use qt4) # use qt4
		$(cmake-utils_use_use ffmpeg) # support ffmpeg
		$(cmake-utils_use_use opencv) # support opencv
		$(cmake-utils_use_use static-libs STATIC) # build static libs
	)
	cmake-utils_src_configure
}
