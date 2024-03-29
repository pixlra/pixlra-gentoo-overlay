# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Calyp is an open-source QT based raw video player"
HOMEPAGE="https://github.com/pixlra/calyp"
LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/pixlra/calyp.git"
EGIT_BRANCH="master"

SLOT=0
KEYWORDS=""

X86_CPU_FEATURES="cpu_flags_x86_sse"
IUSE="+qt5 qt4 ffmpeg opencv static-libs $X86_CPU_FEATURES"

DEPEND="
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
	ffmpeg? ( media-video/ffmpeg )
	opencv? ( media-libs/opencv )
"

RDEPEND="
	${DEPEND}
"

src_configure() {
	local mycmakeargs=(
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON # avoid to fetch content
		-DUSE_SSE=$(usex cpu_flags_x86_sse)
		-DBUILD_APP=$(usex qt5 )
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_STATIC=$(usex static-libs)
	)
	cmake_src_configure
}
