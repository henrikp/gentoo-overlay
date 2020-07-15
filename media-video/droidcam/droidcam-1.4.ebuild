# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 desktop linux-mod xdg-utils

DESCRIPTION="Turn your mobile device into a webcam"
HOMEPAGE="https://www.dev47apps.com/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aramg/droidcam.git"
else
	SRC_URI="https://github.com/aramg/droidcam/archive/v${PV}.tar.gz"
	KEYWORDS="~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"

DEPEND="gtk? (
				dev-cpp/gtkmm:3.0
				media-video/ffmpeg
			)
		!gtk? ( media-video/ffmpeg[-X] )
		=app-pda/libusbmuxd-1*
		media-libs/alsa-lib"
RDEPEND="${DEPEND} dev-util/android-tools"
BDEPEND="=media-libs/libjpeg-turbo-2*
		>=media-libs/speex-1.2.0-r1"

S="${WORKDIR}/${P}/linux"
DOCS=( README.md README-DKMS.md )

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
	if ! use gtk ; then
		sed -i -e '/cflags gtk+/d' Makefile
	fi
	linux-mod_pkg_setup
	default
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
	newins ${FILESDIR}/${PN}-modulesloadd.conf ${PN}.conf
	newdoc ${FILESDIR}/${PN}-modprobe.conf ${PN}.conf.default
	linux-mod_src_install
	einstalldocs
}

pkg_postinst() {
	readme.gentoo_print_elog
	linux-mod_pkg_postinst
	if use gtk ; then
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	linux-mod_pkg_postrm
	if use gtk ; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
		xdg_icon_cache_update
	fi
}
