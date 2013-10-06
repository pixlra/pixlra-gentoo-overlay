# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opencv/opencv-2.4.6.1.ebuild,v 1.1 2013/09/04 18:43:16 dilfridge Exp $

EAPI=5
PYTHON_DEPEND="2:2.6"

inherit base toolchain-funcs cmake-utils python java-pkg-opt-2 java-ant-2 git-2

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="http://opencv.willowgarage.com"
# SRC_URI="mirror://sourceforge/opencvlibrary/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/jfmcarreira/opencv.git"
#EGIT_REPO_URI="https://github.com/Itseez/opencv.git"
#EGIT_SOURCEDIR="${T}/opencv"
EGIT_COMMIT="2.4.6.2_rc1_p1"


LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-fbsd ~amd64-linux"
IUSE="cuda doc eigen examples ffmpeg gstreamer gtk ieee1394 ipp jpeg jpeg2k opencl openexr opengl pch png qt4 testprograms threads tiff v4l xine"

RDEPEND="
	app-arch/bzip2
	dev-python/numpy
	sys-libs/zlib
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2 )
	eigen? ( dev-cpp/eigen:2 )
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10
	)
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
	)
	java? ( >=virtual/jre-1.6 )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/jasper )
	ieee1394? (
		media-libs/libdc1394
		sys-libs/libraw1394
	)
	ipp? ( sci-libs/ipp )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr )
	opengl? ( virtual/glu )
	png? ( media-libs/libpng:0= )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qttest:4
		opengl? ( dev-qt/qtopengl:4 )
	)
	threads? ( dev-cpp/tbb )
	tiff? ( media-libs/tiff )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xine? ( media-libs/xine-lib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6 )
"

# REQUIRED_USE="opengl? ( qt )"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.1a-libav-0.7.patch"
	"${FILESDIR}/${PN}-2.4.3-gcc47.patch"
	"${FILESDIR}/${PN}-2.4.2-cflags.patch"
	"${FILESDIR}/${PN}-2.4.5-javamagic.patch"
)

src_unpack() {
	git-2_src_unpack
}


pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	base_src_prepare

	# remove bundled stuff
	rm -rf 3rdparty
	sed -i \
		-e '/add_subdirectory(3rdparty)/ d' \
		CMakeLists.txt || die

	java-pkg-opt-2_src_prepare
}

src_configure() {
	JAVA_ANT_ENCODING="iso-8859-1"
	# set encoding so even this cmake build will pick it up.
	export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	java-ant-2_src_configure

	# please dont sort here, order is the same as in CMakeLists.txt
	local mycmakeargs=(
	# the optinal dependency libraries
		$(cmake-utils_use_with ieee1394 1394)
		-DWITH_AVFOUNDATION=OFF
		-DWITH_CARBON=OFF
		$(cmake-utils_use_with eigen)
		$(cmake-utils_use_with ffmpeg)
		$(cmake-utils_use_with gstreamer)
		$(cmake-utils_use_with gtk)
		$(cmake-utils_use_with ipp)
		$(cmake-utils_use_with java)
		$(cmake-utils_use_with jpeg2k JASPER)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with opencl)
	#	$(cmake-utils_use_with opencl OPENCLAMDFFT)
	#	$(cmake-utils_use_with opencl OPENCLAMDBLAS)
		$(cmake-utils_use_with openexr)
		$(cmake-utils_use_with opengl)
		-DWITH_OPENNI=OFF					# not packaged
		$(cmake-utils_use_with png)
		-DWITH_PVAPI=OFF					# not packaged
		$(cmake-utils_use_with qt4 QT)
		-DWITH_QUICKTIME=OFF
		$(cmake-utils_use_with threads TBB)
		$(cmake-utils_use_with tiff)
		-DWITH_UNICAP=OFF					# not packaged
		$(cmake-utils_use_with v4l V4L)
		-DWITH_VIDEOINPUT=OFF					# windows only
		-DWITH_XIMEA=OFF					# windows only
		$(cmake-utils_use_with xine)
	# the build components
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ANDROID_EXAMPLES=OFF
		$(cmake-utils_use_build doc DOCS)
		$(cmake-utils_use_build examples)
		-DBUILD_PERF_TESTS=OFF
		$(cmake-utils_use_build testprograms TESTS)
	# install examples
		$(cmake-utils_use examples INSTALL_C_EXAMPLES)
	# build options
		$(cmake-utils_use_enable pch PRECOMPILED_HEADERS)
		-DENABLE_OMIT_FRAME_POINTER=OFF				#
		-DENABLE_FAST_MATH=OFF					#
		-DENABLE_SSE=OFF					# these options do nothing but
		-DENABLE_SSE2=OFF					# add params to CFLAGS
		-DENABLE_SSE3=OFF
		-DENABLE_SSSE3=OFF
		-DENABLE_SSE41=OFF
		-DENABLE_SSE42=OFF
		-DOPENCV_EXTRA_FLAGS_RELEASE=""				# black magic
	)

	if use cuda; then
		if [[ "$(gcc-version)" > "4.6" ]]; then
			ewarn "CUDA and >=sys-devel/gcc-4.7 do not play well together. Disabling CUDA support."
			mycmakeargs+=( "-DWITH_CUDA=OFF" )
			mycmakeargs+=( "-DWITH_CUBLAS=OFF" )
			mycmakeargs+=( "-DWITH_CUFFT=OFF" )
		else
			mycmakeargs+=( "-DWITH_CUDA=ON" )
			mycmakeargs+=( "-DWITH_CUBLAS=ON" )
			mycmakeargs+=( "-DWITH_CUFFT=ON" )
		fi
	else
		mycmakeargs+=( "-DWITH_CUDA=OFF" )
		mycmakeargs+=( "-DWITH_CUBLAS=OFF" )
		mycmakeargs+=( "-DWITH_CUFFT=OFF" )
	fi

	if use examples; then
		mycmakeargs+=( "-DINSTALL_PYTHON_EXAMPLES=ON" )
	else
		mycmakeargs+=( "-DINSTALL_PYTHON_EXAMPLES=OFF" )
	fi

	# things we want to be hard off or not yet figured out
	mycmakeargs+=(
		"-DOPENCV_BUILD_3RDPARTY_LIBS=OFF"
		"-DBUILD_LATEX_DOCS=OFF"
		"-DBUILD_PACKAGE=OFF"
		"-DENABLE_PROFILING=OFF"
	)

	# things we want to be hard enabled not worth useflag
	mycmakeargs+=(
		"-DCMAKE_SKIP_RPATH=ON"
		"-DOPENCV_DOC_INSTALL_PATH=${EPREFIX}/usr/share/doc/${PF}"
	)

	# hardcode cuda paths
	mycmakeargs+=(
		"-DCUDA_NPP_LIBRARY_ROOT_DIR=/opt/cuda"
	)

	# workaround for bug 413429
	tc-export CC CXX

	cmake-utils_src_configure
}
