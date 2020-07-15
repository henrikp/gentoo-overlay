# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple and intuitive framework for the creative process."
HOMEPAGE="https://openframeworks.cc/"
SRC_URI="https://github.com/openframeworks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/pulseaudio
		media-libs/openal
		media-libs/gstreamer:1.0
		media-sound/mpg123
		<dev-libs/boost-1.73.0
		dev-cpp/gtkmm:3.0
		virtual-jack
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
		media-libs/libsndfile"

PATCHES=(
		# https://forum.openframeworks.cc/t/compilation-failing-due-to-confliting-definition-in-openal/33927/2
		"${FILESDIR}"/openFrameworks-0.11.0-OpenAL-fixes.patch
)
