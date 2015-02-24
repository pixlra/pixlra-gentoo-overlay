# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils cmake-utils git-r3

DESCRIPTION="plaYUVer is an open-source QT based raw video player"
HOMEPAGE="https://github.com/pixlra/playuver"

EGIT_REPO_URI="https://github.com/pixlra/playuver.git"
EGIT_BRANCH="devel"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+qt5 -qt4 ffmpeg opencv"

DEPEND="
  qt5? (
    dev-qt/qtcore:5
    dev-qt/qtgui:5
    dev-qt/qtwidgets:5
	dev-qt/qtprintsupport:5
	dev-qt/qtdbus:5
  )
  qt4? (
    dev-qt/qtcore:4
    dev-qt/qtgui:4
	dev-qt/qtdbus:4
  )
  ffmpeg? ( virtual/ffmpeg )
  opencv? ( qt5? ( media-libs/opencv[-qt4] ) !qt5? ( media-libs/opencv[-qt5] ) )
"

RDEPEND="${DEPEND}"

REQUIRED_USE="
  ?? ( qt5 qt4 )
"


src_configure() {
  local mycmakeargs=(
    $(cmake-utils_use_use qt4) # use qt5
    $(cmake-utils_use_use ffmpeg) # support ffmpeg
    $(cmake-utils_use_use opencv) # support opencv
  )
  cmake-utils_src_configure
}
