# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Linux command-line VBAN tools"
HOMEPAGE="https://github.com/quiniouben/vban"
SRC_URI="https://github.com/quiniouben/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa jack pulseaudio"

DEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( virtual/jack )
		pulseaudio? ( media-sound/pulseaudio )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable pulseaudio)
}

pkg_postinst() {
	einfo "This project contains only command line tools."
	#einfo "If you are looking for a GUI, you can take a look at:"
	#einfo "media-sound/vban-manager"
}
