# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="tizonia-openmax-il"
SRC_URI="https://github.com/${PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
KEYWORDS="~amd64"
DESCRIPTION="Command-line cloud music player."
HOMEPAGE="http://tizonia.org"
LICENSE="LGPL-3.0+"
PYTHON_COMPAT=( python3_{7,8} )

inherit meson python-r1 systemd xdg-utils

SLOT="0"

IUSE="+aac +alsa +bash-completion blocking-etb-ftb blocking-sendcommand
	+boost +curl +dbus +file-io +flac +fuzzywuzzy +inproc-io
	mp4 +ogg +opus +lame +libsndfile +mad +mp3-metadata-eraser +mp2 +mpg123
	+player +pulseaudio +python +sdl +icecast-client +icecast-server
	-test +vorbis +vpx +webm +zsh-completion openrc systemd
	+chromecast +google-music +plex +soundcloud +spotify +tunein +youtube"
REQUIRED_USE="chromecast? ( player python boost curl dbus google-music )
		dbus? ( || ( openrc systemd ) )
		google-music? ( player python boost fuzzywuzzy curl )
		icecast-client? ( player curl )
		icecast-server? ( player )
		mp2? ( mpg123 )
		mp3-metadata-eraser? ( mpg123 )
		ogg? ( curl )
		openrc? ( dbus )
		player? ( boost )
		plex? ( player python boost fuzzywuzzy curl )
		python? ( ${PYTHON_REQUIRED_USE} )
		python? ( || ( chromecast google-music plex soundcloud spotify
			tunein youtube ) )
		!python? ( !chromecast !google-music !plex !soundcloud !spotify
			!tunein !youtube )
		soundcloud? ( player python boost fuzzywuzzy curl )
		spotify? ( player python boost fuzzywuzzy )
		tunein? ( player python boost fuzzywuzzy curl )
		systemd? ( dbus )
		youtube? ( player python boost fuzzywuzzy curl )"
# 3rd party repos may be required and add to package.unmask.  use layman -a
# =dev-python/gmusicapi-12.1.1::palmer
# =dev-python/gpsoauth-0.4.1::palmer
# =dev-python/proboscis-1.2.6.0::palmer
# =dev-python/python-plexapi-3.0.6::oiledmachine-overlay
# =dev-python/soundcloud-python-9999.20151015::oiledmachine-overlay
# =dev-python/validictory-1.1.2::palmer
# =media-libs/nestegg-9999.20190603::oiledmachine-overlay

# keywords/unmask if using multilib with 32 bit
# dev-libs/libspotify::oiledmachine-overlay
# dev-libs/log4c::oiledmachine-overlay
# media-libs/opusfile::oiledmachine-overlay
# media-libs/liboggz::
# media-libs/libmp4v2::oiledmachine-overlay
# media-libs/libfishsound::oiledmachine-overlay

# masks if using multilib with 32 bit
# dev-libs/libspotify::gentoo
# media-libs/liboggz::gentoo
# media-libs/opusfile::gentoo
# media-libs/libmp4v2::gentoo
# media-libs/libfishsound::gentoo

#
# ogg_muxer requires curl, oggmuxsnkprc.c is work in progress.  ogg should
# work without curl for just strictly local playback only (as in non streaming
# player) tizonia
#
# >=dev-python/dnspython-1.16.0 added to avoid merge conflict between pycrypto
# and pycryptodome.  It should not be here but resolved in dnspython.
RDEPEND="aac? ( media-libs/faad2 )
		alsa? ( media-libs/alsa-lib )
		bash-completion? ( app-shells/bash )
		boost? ( >=dev-libs/boost-1.54[${PYTHON_USEDEP}] )
		chromecast? ( || ( dev-python/PyChromecast[${PYTHON_USEDEP}]
			dev-python/pychromecast[${PYTHON_USEDEP}] ) )
		curl? ( >=net-misc/curl-7.18.0 )
		flac? ( >=media-libs/flac-1.3.0 )
		fuzzywuzzy? ( dev-python/fuzzywuzzy[${PYTHON_USEDEP}] )
		google-music? ( dev-python/gmusicapi[${PYTHON_USEDEP}] )
		inproc-io? ( >=net-libs/zeromq-4.0.4 )
		lame? ( media-sound/lame )
		ogg? ( >=media-libs/liboggz-1.1.1 )
		opus? ( >=media-libs/opusfile-0.5 )
		dbus? ( sys-apps/dbus )
		libsndfile? ( >=media-libs/libsndfile-1.0.25 )
		mp4? ( media-libs/libmp4v2 )
		mad? ( media-libs/libmad )
		mpg123? ( >=media-sound/mpg123-1.16.0 )
		opus? ( >=media-libs/opus-1.1 )
		player? ( >=media-libs/libmediainfo-0.7.65
			>=media-libs/taglib-1.7.0 )
		plex? ( dev-python/python-plexapi[${PYTHON_USEDEP}] )
		pulseaudio? ( >=media-sound/pulseaudio-1.1 )
		sdl? ( media-libs/libsdl )
		soundcloud? ( dev-python/soundcloud-python[${PYTHON_USEDEP}] )
		spotify? ( >=dev-libs/libspotify-12.1.51-r2 )
		>=sys-apps/util-linux-2.19.0
		test? ( dev-db/sqlite:3 )
		vorbis? ( media-libs/libfishsound )
		vpx? ( media-libs/libvpx )
		youtube? ( dev-python/pafy[${PYTHON_USEDEP}]
			net-misc/youtube-dl[${PYTHON_USEDEP}] )
		webm? ( media-libs/nestegg )
		zsh-completion? ( app-shells/zsh )"
DEPEND="${RDEPEND}
	media-libs/libzen
	>=dev-libs/check-0.9.4
	>=dev-libs/log4c-1.2.1"
BDEPEND=">=dev-util/meson-0.54.2
		dev-util/ninja"
RESTRICT="mirror"

python_configure_all() {
	L=$(find . -name "Makefile.am")
	for l in $L ; do
		einfo "Patching $l for -lboost_python to -lboost_${EPYTHON//./}"
		sed -i "s|-lboost_python36|-lboost_${EPYTHON//./}|g" $l || die
	done
	L=$(find . -name "*.pc.in")
	for l in $L ; do
		einfo "Patching $l for -lpython3.6m to -l${EPYTHON}m"
		sed -i "s|-lpython3.6m|-l${EPYTHON}m|g" $l || die
		einfo "Patching $l for -lboost_python36 to -lboost_${EPYTHON//./}"
		sed -i "s|-lboost_python36|-lboost_${EPYTHON//./}|g" $l || die
	done
}

src_configure() {
	python_foreach_impl python_configure_all
	local myconf
	if use bash-completion ; then
		myconf+=" -Dbashcompletiondir=/usr/share/bash-completion/completions"
	fi
	if use zsh-completion ; then
		myconf+=" -Dzshcompletiondir=/usr/share/zsh/vendor-completions"
	fi
	python_setup
	local emesonargs=(
		$(meson_use aac)
		$(meson_use alsa)
		$(meson_feature alsa options:pcm_renderer_alsa)
		$(meson_use blocking-sendcommand)
		$(meson_use blocking-etb-ftb)
		$(meson_feature chromecast options:chromecast_renderer)
		$(meson_feature file-io options:file_reader)
		$(meson_feature file-io options:file_writer)
		$(meson_feature flac options:flac_decoder)
		$(meson_feature icecast-client options:http_renderer)
		$(meson_feature icecast-server options:http_source)
		$(meson_feature inproc-io options:inproc_reader)
		$(meson_feature inproc-io options:inproc_writer)
		$(meson_feature lame options:mp3_decoder)
		$(meson_feature lame options:mp3_encoder)
		$(meson_feature mp3-metadata-eraser options:mp3_metadata)
		$(meson_feature mp4 options:mp4_demuxer)
		$(meson_feature mp2 options:mpeg_audio_decoder)
		$(meson_feature ogg options:ogg_demuxer)
		$(meson_feature ogg options:ogg_muxer)
		$(meson_feature ogg options:vorbis_decoder)
		$(meson_feature opus options:opus_decoder)
		$(meson_feature opus options:opusfile_decoder)
		$(meson_feature pulseaudio options:pcm_renderer_pa)
		$(meson_use spotify libspotify)
		$(meson_feature spotify options:spotify)
		$(meson_feature youtube options:yuv_renderer)
		$(meson_use test)
		$(meson_feature vorbis options:vorbis_decoder)
		$(meson_feature vpx options:vp8_decoder)
		$(meson_feature webm options:webm_demuxer)
		$(meson_use player)
		${myconf}
	)
	meson_src_configure
}

src_compile() {
	cd "${BUILD_DIR}"
	eninja
}

src_test() {
	cd "${BUILD_DIR}"
	eninja test
}

src_install() {
	# fixes header mismatch
	insinto /usr/include/tizonia/
	if use chromecast ; then
		pushd clients/chromecast/libtizchromecast/src || die
		doins tizchromecastctxtypes.h \
			tizchromecastctx_c.h \
			tizchromecast_c.h \
			tizchromecastctx.hpp \
			tizchromecast.hpp \
			tizchromecasttypes.h
		popd
	fi
	if use google-music ; then
		pushd clients/gmusic/libtizgmusic/src || die
		doins tizgmusic.hpp tizgmusic_c.h
		popd
	fi
	if use plex ; then
		pushd clients/plex/libtizplex/src || die
		doins tizplex.hpp tizplex_c.h
		popd
	fi
	if use soundcloud ; then
		pushd clients/soundcloud/libtizsoundcloud/src || die
		doins tizsoundcloud.hpp tizsoundcloud_c.h
		popd
	fi
	if use spotify ; then
		pushd clients/spotify/libtizspotify/src || die
		doins tizspotify.hpp tizspotify_c.h
		popd
	fi
	if use tunein ; then
		pushd clients/tunein/libtiztunein/src || die
		doins tiztunein.hpp tiztunein_c.h
		popd
	fi
	if use youtube ; then
		pushd clients/youtube/libtizyoutube/src || die
		doins tizyoutube.hpp tizyoutube_c.h
		popd
	fi
	cd "${BUILD_DIR}"
	DESTDIR=${D} eninja install
	python_optimize
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
