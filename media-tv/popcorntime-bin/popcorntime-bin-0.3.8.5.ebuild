# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fdo-mime multilib versionator

DESCRIPTION="Watch torrent movies instantly"
HOMEPAGE="http://popcorn.cdnjd.com/"

VERSION=$(get_version_component_range 1-3)
PATCH=$(get_version_component_range 4)


SRC_URI="x86?   ( http://mirror01.ptn.sh/build/Popcorn-Time-${VERSION}-${PATCH}-Linux-32.tar.xz )
		 amd64? ( http://mirror01.ptn.sh/build/Popcorn-Time-${VERSION}-${PATCH}-Linux-64.tar.xz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="splitdebug strip"

DEPEND=""
RDEPEND="dev-libs/nss
	gnome-base/gconf
	media-fonts/corefonts
	media-libs/alsa-lib
	x11-libs/gtk+:2"

S="${WORKDIR}"

src_install() {

	exeinto /opt/${PN}
	doexe Popcorn-Time libffmpegsumo.so nw.pak package.json


    insinto /opt/${PN}
	doins package.json icudtl.dat
	doins -r src node_modules locales


	dosym /$(get_libdir)/libudev.so.1 /opt/${PN}/libudev.so.0
	make_wrapper ${PN} ./Popcorn-Time /opt/${PN} /opt/${PN} /opt/bin

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop

	insinto /usr/share/pixmaps
	doins "${FILESDIR}"/${PN}.png
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
