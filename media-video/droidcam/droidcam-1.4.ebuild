# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 desktop linux-mod xdg-utils

DESCRIPTION="Turn your mobile device into a webcam"
HOMEPAGE="https://www.dev47apps.com/"
SRC_URI="https://github.com/aramg/droidcam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"
RESTRICT="bindist mirror"

DEPEND="gtk? (
				dev-cpp/gtkmm:3.0
				media-video/ffmpeg
			)
		!gtk? ( media-video/ffmpeg[-X] )
		=app-pda/libusbmuxd-1*
		media-libs/alsa-lib"
RDEPEND="${DEPEND} dev-util/android-tools"
BDEPEND="=media-libs/libjpeg-turbo-2*
		>=media-libs/speex-1.2.0-r1
		virtual/pkgconfig"

S="${WORKDIR}/${P}/linux"
DOCS=( README.md README-DKMS.md )
DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="
		The default resolution for v4l2loopback-dc[1] is 640x480. You can override the
		value by copying droidcam.conf.default to /etc/modprobe.d/droidcam.conf
		and modifying 'width' and 'height'.

		[1] https://github.com/aramg/droidcam/issues/56
"

BUILD_TARGETS="all"
MODULE_NAMES="v4l2loopback-dc(video:${S}/v4l2loopback:${S}/v4l2loopback)"
CONFIG_CHECK="~SND_ALOOP MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT"
ERROR_SND_ALOOP="CONFIG_SND_ALOOP: missing, required for audio support"

PATCHES=(
		"${FILESDIR}"/${P}-Makefile-fixes.patch
)

src_configure() {
	true
}

src_prepare() {
	default
	if ! use gtk ; then
		sed -i -e '/cflags gtk+/d' Makefile
	fi
	linux-mod_pkg_setup
}

src_compile() {
	if use gtk ; then
		emake droidcam
	fi
	emake droidcam-cli
	linux-mod_src_compile
}

src_install() {
	if use gtk ; then
		dobin droidcam
		newicon -s 32 icon.png droidcam.png
		newicon -s 48 icon2.png droidcam.png
		make_desktop_entry "${PN}" "DroidCam Client" "${PN}" AudioVideo
	fi
	dobin droidcam-cli
	readme.gentoo_create_doc
	insinto /etc/modules-load.d
	newins "${FILESDIR}"/${PN}-modulesloadd.conf ${PN}.conf
	newdoc "${FILESDIR}"/${PN}-modprobe.conf ${PN}.conf.default
	einstalldocs
	linux-mod_src_install
}

pkg_postinst() {
	if use gtk ; then
		xdg_icon_cache_update
	else
		elog
		elog "Only droidcam-cli has been installed since no 'gtk' flag was present"
		elog "in the USE list."
		elog
	fi
	readme.gentoo_print_elog
	linux-mod_pkg_postinst
}

pkg_postrm() {
	if use gtk ; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi
	linux-mod_pkg_postrm
}
