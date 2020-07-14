# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Test: OpenRC, right paths for modules, adb

EAPI=7

inherit desktop linux-info linux-mod xdg-utils

CONFIG_PROTECT_MASK="/lib/modules"
DESCRIPTION="Turn your mobile device into a webcam"
HOMEPAGE="https://www.dev47apps.com/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 linux-mod
	EGIT_REPO_URI="https://github.com/aramg/droidcam.git"
else
	SRC_URI="https://github.com/aramg/droidcam/archive/v${PV}.tar.gz"
	KEYWORDS="~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk systemd"

DEPEND="gtk? (
				dev-cpp/gtkmm:3.0
				media-video/ffmpeg
		)
		!gtk? ( media-video/ffmpeg[-X] )
		=app-pda/libusbmuxd-1*[static-libs]
		media-libs/alsa-lib"
RDEPEND="${DEPEND} dev-util/android-tools"
BDEPEND="=media-libs/libjpeg-turbo-2*[static-libs]
		>=media-libs/speex-1.2.0-r1"
S="${WORKDIR}/${P}/linux"
DOCS=( README.md README-DKMS.md )

BUILD_TARGETS="all"
MODULE_NAMES="v4l2loopback-dc(video:${S}/v4l2loopback:${S}/v4l2loopback)"
CONFIG_CHECK="~SND_ALOOP MEDIA_SUPPORT MEDIA_CAMERA_SUPPORT"
ERROR_SND_ALOOP="CONFIG_SND_ALOOP: missing, required for audio"

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
		make_desktop_entry "${PN}" "Droidcam Client" "${PN}" AudioVideo
	fi
	dobin droidcam-cli
	linux-mod_src_install
	einstalldocs
}

pkg_postinst() {
	# check if snd_aloop is a module, and act accordingly
	if  linux_config_exists && \
	    linux_chkconfig_module SND_ALOOP && \
	    use systemd ; then
		elog 
		elog "AUDIO: General sound loopback driver activated on boot."
		elog "To load it right away, type:"
		elog "# modprobe snd_aloop"
        elog
		echo "snd_aloop" > /etc/modules-load.d/snd_aloop.conf
	else
		elog "TODO: Load snd_aloop on startup with OpenRC" 
	fi
	if use systemd ; then
		elog
		elog "VIDEO: Custom V4L2 kernel module installed to /etc/, type:"
		elog "# modprobe v4l2loopback_dc"
		elog "to load it right away."
		elog
		echo "v4l2loopback_dc" > /etc/modules-load.d/v4l2loopback_dc.conf
	else
		elog "TODO: Load v4l2loopback-dc on startup with OpenRC"
	fi
	linux-mod_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	linux-mod_pkg_postrm
	xdg_icon_cache_update
}
