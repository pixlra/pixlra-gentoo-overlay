# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils unpacker versionator

DESCRIPTION="Middleware do Cartao de Cidadao"
HOMEPAGE="https://www.cartaodecidadao.pt"
LICENSE="Licence-Cartao-Cidadao-App"

SRC_URI="amd64? ( https://www.autenticacao.gov.pt/documents/10179/11962/Aplica%C3%A7%C3%A3o+do+Cart%C3%A3o+de+Cidad%C3%A3o+%28Linux+-+Ubuntu+-+64+bits%29%20%28v.1.61.0%29%20Jan+2016/013924f5-dee7-4eeb-ac82-ef81e3db1dec )"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-crypt/ccid
	dev-libs/openssl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/jasper
	sys-apps/pcsc-lite
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"
DESTDIR="${D}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	cp -R "${WORKDIR}/usr" "${D}" || die "install failed!"

	VERSION=${PV}
	DEB_INSTALL_DIR=/usr/local/lib

	dosym $DEB_INSTALL_DIR/libpteidpkcs11.so.$VERSION $DEB_INSTALL_DIR/libpteidpkcs11.so
	dosym $DEB_INSTALL_DIR/libpteidlibopensc.so.$VERSION $DEB_INSTALL_DIR/libpteidlibopensc.so
	dosym $DEB_INSTALL_DIR/libpteid.so.$VERSION $DEB_INSTALL_DIR/libpteid.so
	dosym $DEB_INSTALL_DIR/libpteiddlg.so.$VERSION $DEB_INSTALL_DIR/libpteiddlg.so
	dosym $DEB_INSTALL_DIR/libpteidhttps.so.$VERSION $DEB_INSTALL_DIR/libpteidhttps.so

	dosym $DEB_INSTALL_DIR/pteidpp/libpteidpp1_gempc.so.$VERSION $DEB_INSTALL_DIR/pteidpp/libpteidpp1_gempc.so
	dosym $DEB_INSTALL_DIR/pteid_jni/libpteidlibj.so.$VERSION $DEB_INSTALL_DIR/pteid_jni/libpteidlibj.so

	dosym $DEB_INSTALL_DIR/libpteidlibopensc.so.$VERSION $DEB_INSTALL_DIR/libpteidlibopensc.so.1
	dosym $DEB_INSTALL_DIR/libpteid.so.$VERSION $DEB_INSTALL_DIR/libpteid.so.1
	dosym $DEB_INSTALL_DIR/libpteidhttps.so.$VERSION $DEB_INSTALL_DIR/libpteidhttps.so.1

}
