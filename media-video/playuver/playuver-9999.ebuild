# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils qt4-r2 cmake-utils git-2

DESCRIPTION="plaYUVer is an open-source QT based raw video player"
HOMEPAGE="https://github.com/pixlra/playuver"

EGIT_REPO_URI="https://github.com/pixlra/playuver.git"
# EGIT_COMMIT="${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde qt5 -qt4 -ffmpeg -opencv debug"

DEPEND="
  qt5? (
    dev-qt/qtcore:5
    dev-qt/qtgui:5
    dev-qt/qtwidgets:5
  )
  qt4? (
    dev-qt/qtcore:4
    dev-qt/qtgui:4
  )
  ffmpeg? ( media-video/ffmpeg )
  opencv? ( media-libs/opencv )
"
  
RDEPEND="${DEPEND}"

REQUIRED_USE="
  qt5? ( !qt4 )
"

S="${WORKDIR}/${PN}"

src_unpack() {
	git-2_src_unpack
}

# src_prepare() {
#   base_src_prepare
# }

src_configure() {
  local mycmakeargs=(
    $(cmake-utils_use_use qt4) # ffmpeg
    $(cmake-utils_use_use ffmpeg) # ffmpeg
    $(cmake-utils_use_use opencv) # ffmpeg
  )
  if use kde; then
    mycmakeargs+=( -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` )
  fi
  cmake-utils_src_configure
}

src_compile() {
  cmake-utils_src_compile
}

# src_install() {
#   cmake-utils_src_install
# }
