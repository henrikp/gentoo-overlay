# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"
SRC_URI="https://github.com/love2d/${PN}/releases/download/${PV}/${P}-linux-src.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="ZLIB"
SLOT="0.8"

DEPEND="
	dev-games/physfs
	dev-lang/lua:0[deprecated]
	media-libs/devil[mng,png,tiff]
	media-libs/freetype:2
	media-libs/libmodplug
	media-libs/libsdl[joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl
"
RDEPEND="${DEPEND}
	media-libs/libmng:0
	media-libs/tiff:0
"

PATCHES=( "${FILESDIR}"/${P}-freetype2.patch 
		  "${FILESDIR}"/${P}-glDeleteBuffers.patch )

src_install() {
	DOCS="readme.md changes.txt" \
		default

	mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}-${SLOT}" || die
}
