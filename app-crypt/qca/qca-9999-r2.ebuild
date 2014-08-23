# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib cmake-utils git-2

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
EGIT_REPO_URI="git://anongit.kde.org/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS=""
# IUSE="aqua botan debug doc examples gpg gcrypt logger nss pkcs11 +qt4 qt5 sasl softstore ssl test"
IUSE="aqua botan debug doc examples gpg gcrypt logger nss pkcs11 +qt4 qt5 sasl softstore openssl test"

RESTRICT="test" 

RDEPEND="
        !app-crypt/qca-cyrus-sasl
        !app-crypt/qca-gnupg
        !app-crypt/qca-logger
        !app-crypt/qca-ossl
        !app-crypt/qca-pkcs11
        botan? ( dev-libs/botan )
	gpg? ( app-crypt/gnupg )
	gcrypt? ( dev-libs/libgcrypt:= )
	nss? ( dev-libs/nss )
	
	openssl? ( dev-libs/openssl:0 )
        pkcs11? (
                dev-libs/openssl:0
                dev-libs/pkcs11-helper
        )
	qt4? ( dev-qt/qtcore:4 )
        qt5? (
                dev-qt/qtcore:5
                dev-qt/qtconcurrent:5
                dev-qt/qtnetwork:5
        )
        sasl? ( dev-libs/cyrus-sasl )
"

DEPEND="${RDEPEND} 
        doc? ( app-doc/doxygen )
        test? (
                qt4? ( dev-qt/qttest:4 )
                qt5? ( dev-qt/qttest:5 )
        )
        qt4? ( dev-qt/qttest:4[debug?] )
	qt5? ( dev-qt/qttest:5[debug?] )
"

# DEPEND="${RDEPEND} qt4? ( dev-qt/qttest:4[debug?] )
# 	qt5? ( dev-qt/qttest:5[debug?] )"

REQUIRED_USE="|| ( qt4 qt5 )"

DOCS=( README TODO )

qca_plugin_use() {
        echo "-DWITH_${2:-$1}_PLUGIN=$(use $1 && echo yes || echo no)"
}

wrap_stage() {
	stage=$1
	for qt in qt4 qt5; do
		use $qt && {
			BUILD_DIR="${WORKDIR}/${PN}-${qt}-build" \
			QT=$qt $stage
		}
	done
}

src_configure()
{
	my_configure() {
	
                local mycmakeargs=(
                        -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
			"-DPKGCONFIG_INSTALL_PREFIX=${EPREFIX}/usr/$(get_libdir)/pkgconfig"
			-DQC_CERTSTORE_PATH="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
			-DQCA_MAN_INSTALL_DIR="${EPREFIX}/usr/share/man"
			-DBUILD_PLUGINS=none
                        
                        $(cmake-utils_use qt4 QT4_BUILD)
                        $(qca_plugin_use botan)
                        $(qca_plugin_use gcrypt)
                        $(qca_plugin_use gpg gnupg)
                        $(qca_plugin_use logger)
                        $(qca_plugin_use nss)
                        $(qca_plugin_use openssl ossl)
                        $(qca_plugin_use pkcs11)
                        $(qca_plugin_use sasl cyrus-sasl)
                        $(qca_plugin_use softstore)
                        $(cmake-utils_use_build test TESTS)
                )
                [ "$QT" = qt4 ] && mycmakeargs+=("-DQT4_BUILD=1")
		[ "$QT" = qt5 ] && mycmakeargs+=("-DQCA_SUFFIX=qt5")
		
		cmake-utils_src_configure
	}
	wrap_stage my_configure
}

src_compile()
{
	wrap_stage cmake-utils_src_compile
}

src_test()
{
	wrap_stage enable_cmake-utils_src_test
}

src_install() {
	my_install() {
		cmake-utils_src_install
		dodoc README TODO || die "dodoc failed"

		if use doc; then
			dohtml "${S}"/apidocs/html/* || die "Failed to install documentation"
		fi

		if use examples; then
			insinto /usr/share/doc/${PF}/
			doins -r "${S}"/examples || die "Failed to install examples"
		fi
	}
	wrap_stage my_install
}
