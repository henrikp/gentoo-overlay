# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple and intuitive framework for the creative process."
HOMEPAGE="https://openframeworks.cc/"
SRC_URI="https://github.com/openframeworks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		amd64? ( http://ci.openframeworks.cc/libs/openFrameworksLibs_master_linux64gcc6.tar.bz2 -> ${P}-${ARCH}-libs.tar.bz2 )"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
S="${WORKDIR}"/openFrameworks-"${PV}"

DEPEND="media-sound/pulseaudio
		media-libs/openal
		media-libs/gstreamer:1.0
		media-sound/mpg123
		<dev-libs/boost-1.73.0
		dev-cpp/gtkmm:3.0
		virtual/jack
		media-libs/alsa-lib
		media-libs/mesa
		sys-libs/libraw1394
		x11-libs/libXmu
		media-libs/freetype
		media-libs/opencv
		sys-devel/gdb
		net-misc/curl
		gnome-base/gconf"
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/poco
		dev-libs/pugixml
		dev-libs/uriparser
		dev-libs/openssl
		media-libs/assimp
		media-libs/freeimage
		media-libs/glfw
		media-libs/rtaudio
		media-libs/libsndfile
		dev-libs/libutf8proc
		media-libs/libsvgtiny
		sys-libs/zlib
		x11-libs/pixman
		>=sys-devel/gcc-6.3.0"

PATCHES=(
		# https://forum.openframeworks.cc/t/compilation-failing-due-to-confliting-definition-in-openal/33927/2
		"${FILESDIR}"/openframeworks-0.11.0-OpenAL-fixes.patch
)

src_unpack() {
	unpack "${P}".tar.gz
	cd "${S}"/libs
	rm -rf {fmodex,glm,json,kiss,libxml2,poco,svgtiny,tess2,utf8}
	unpack "${P}"-"${ARCH}"-libs.tar.bz2
}

src_compile() {
	#cd "${S}"/scripts/linux/
	#./compileOF.sh || die "Build failed!"
	export LIBSPATH=linux64
	emake Debug
}

