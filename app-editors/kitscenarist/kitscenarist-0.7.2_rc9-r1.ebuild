# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop font qmake-utils xdg-utils

MY_PV="0.7.2.rc9i"
MY_P="${PN}"-"${MY_PV}"
DESCRIPTION="Simple application for creating screenplays."
HOMEPAGE="https://kitscenarist.ru/en/"
SRC_URI="https://github.com/dimkanovikov/KITScenarist/releases/download/"${MY_PV}"/src.tar.gz -> "${MY_P}".tar.gz"
S="${WORKDIR}/src"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fonts"

FONT_SUFFIX="ttf"
FONT_S="${S}/bin/scenarist-core/Resources/Fonts"
FONT_CONF=""

DEPEND="dev-qt/qtcore
		dev-qt/qtconcurrent
		dev-qt/qtdbus
		dev-qt/qtgui
		dev-qt/qtmultimedia
		dev-qt/qtnetwork
		dev-qt/qtopengl
		dev-qt/qtpositioning
		dev-qt/qtprintsupport
		dev-qt/qtquickcontrols
		dev-qt/qtwidgets
		dev-qt/qtsql
		dev-qt/qtsvg
		dev-qt/qtwebchannel
		dev-qt/qtwebengine
		dev-qt/qtxml
		sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	xdg_environment_reset
	default
}

src_configure() {
	lrelease -silent Scenarist.pro
	eqmake5 Scenarist.pro
}

src_compile() {
	emake qmake_all
	emake
}

src_install() {
	newicon -s scalable bin/scenarist-core/Resources/Icons/logo.png "${PN}".png
	make_desktop_entry Scenarist "KIT Scenarist" "${PN}" Office
	dobin "${WORKDIR}"/build/Release/bin/scenarist-desktop/Scenarist
	font_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	font_pkg_postinst
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	font_pkg_postrm
}
