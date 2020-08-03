# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit flag-o-matic wxwidgets xdg cmake

MY_P="Audacity-${PV}"
# There are no tags, so we have to look at commit messages
DOC_COMMIT="9b5cc7acb9187dbda028b82267ab3bf6a259b560" # for 2.4.2
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org/"
SRC_URI="https://github.com/audacity/audacity/archive/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
# Disabling doc for testing
IUSE="alsa cpu_flags_x86_sse -doc ffmpeg +flac id3tag jack +ladspa +lame
	+lv2 mad midi nls +portmixer sbsms +soundtouch twolame vamp +vorbis +vst"

RESTRICT="test"

RDEPEND="dev-libs/expat
	>=media-libs/libsndfile-1.0.28
	>=media-libs/portaudio-19.06.00-r2[alsa?]
	<media-libs/portaudio-20
	media-libs/soxr
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( >=media-video/ffmpeg-1.2:= )
	flac? ( >=media-libs/flac-1.3.1[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lame? ( >=media-sound/lame-3.70 )
	lv2? (
		media-libs/lilv
		media-libs/lv2
		media-libs/suil
	)
	mad? ( >=media-libs/libmad-0.15 )
	sbsms? ( media-libs/libsbsms )
	soundtouch? ( >=media-libs/libsoundtouch-1.7.1 )
	twolame? ( media-sound/twolame )
	vamp? ( >=media-libs/vamp-plugin-sdk-2.5 )
	vorbis? ( >=media-libs/libvorbis-1.3.3 )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-Fix-building-against-system-portaudio.patch
	"${FILESDIR}"/${P}-Fix-vertical-track-resizing.patch
#	"${FILESDIR}"/${PN}-2.3.3-fno-common.patch # Merged upstream
)

src_prepare() {
	cmake_src_prepare

	use midi || sed -i \
		-e 's:^\(#define EXPERIMENTAL_MIDI_OUT\):// \1:' \
		src/Experimental.h || die
}

src_configure() {
	setup-wxwidgets
	append-cxxflags -std=gnu++14
		local mycmakeargs=(
#		$(cmake-utils_use cpu_flags_x86_sse sse)
#		$(cmake-utils_use ladspa)
#		$(cmake-utils_use nls)
#		$(cmake-utils_use vst)
#		$(cmake-utils_use ffmpeg)
#		$(cmake-utils_use flac libflac)
#		$(cmake-utils_use id3tag libid3tag)
#		$(cmake-utils_use lame)
		-DUSE_LV2="$(usex lv2)"
		-DUSE_LIBMAD="$(usex mad)"
#		$(cmake-utils_use midi portmidi local)
#		$(cmake-utils_use midi "" local)
#		$(cmake-utils_use portmixer)
#		$(cmake-utils_use sbsms)
#		$(cmake-utils_use soundtouch)
#		$(cmake-utils_use twolame libtwolame)
#		$(cmake-utils_use vamp libvamp)
#		$(cmake-utils_use vorbis libvorbis)
		)

		cmake_src_configure

	# * always use system libraries if possible
	# * options listed in the order that configure --help lists them
#	local myeconfargs=(
#		--disable-dynamic-loading
#		--enable-nyquist=local
#		--enable-unicode
#		--with-expat
#		--with-lib-preference=system
#		--with-libsndfile
#		--with-libsoxr
#		--with-mod-script-pipe
#		--with-mod-nyq-bench
#		--with-portaudio
#		--with-widgetextra=local
#		--with-wx-version=${WX_GTK_VER}
#	)
#	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	# Remove bad doc install
	rm -r "${ED}"/usr/share/doc || die

	# Install our docs
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/manual/{m,man,manual}
		dodoc "${WORKDIR}"/manual/{favicon.ico,index.html,quick_help.html}
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
