# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
    EGIT_REPO_URI="https://github.com/love2d/${PN}"
	SRC_URI=""
	KEYWORDS=""
else
	COMMIT="9f62bafea2b8bfb3c7e4c2f6098eb88661fb98b9"
	SRC_URI="https://github.com/love2d/${PN}/archive/${COMMIT}.tar.gz"
    S="${WORKDIR}/${PN}-${COMMIT}"	
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"

LICENSE="ZLIB"
SLOT="0"

DEPEND="sys-libs/zlib
	dev-lang/luajit:2
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl2[joystick,opengl]
	media-libs/libogg
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl"
RDEPEND="${DEPEND}"

DOCS=( "readme.md" "changes.txt" )

src_prepare() {
	default
	./platform/unix/automagic || die
}

src_configure() {
	econf --with-lua=luajit
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
	if [[ ${SLOT} != 0 ]]
	then
		mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}-${SLOT}" || die
		mv "${ED}"/usr/share/applications/love{,"-$SLOT"}.desktop || die
		sed -i -e "/^Name=/s/$/ ($SLOT)/" -e "s|/usr/bin/love|/usr/bin/love-$SLOT|" "${ED}/usr/share/applications/love-$SLOT.desktop" || die
		rm -r "${ED}"/usr/{lib64/liblove.so,share/{mime/,pixmaps/,icons/,man/}} || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
