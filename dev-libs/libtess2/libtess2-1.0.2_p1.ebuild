# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

DESCRIPTION="Polygon tesselator and triangulator."
HOMEPAGE="https://github.com/memononen/libtess2"
EGIT_REPO_URI="https://github.com/memononen/libtess2.git"
EGIT_COMMIT="fc52516467dfa124bdd967c15c7cf9faf02a34ca"

LICENSE="SGI-B-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DOCS=( README.md )

DEPEND="media-libs/glew:0"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/premake:4"

src_prepare() {
	sed -i \
		-e "s/StaticLib/SharedLib/" \
		-e "s/Symbols\",/Symbols\", \"Optimize\", /" \
		"${S}"/premake4.lua || die "Unable to patch premake4.lua !"
	sed -i \
		-e "s/\"nanosvg.h\"/<nanosvg.h>/" \
		-e "s/\"tesselator.h\"/<tesselator.h>/" \
		"${S}"/Example/example.c || die "Unable to patch example.c !"
	sed -i \
		-e "s/\"nanosvg.h\"/<nanosvg.h>/" \
		"${S}"/Contrib/nanosvg.c || die "Unable to patch nanosvg.c !"
	premake4 gmake
	sed -i \
		-e "s/+= \$(LDDEPS)/+= \$(LDDEPS) -Wl,-soname,libtess2.so/" \
		"${S}"/Build/tess2.make || die "Unable to patch tess2.make !"
	default
}

src_compile() {
	MAKEARGS=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		LINK="$(tc-getCC)"
		ARCH=""
	)
	emake verbose=1 -C Build \
		"${MAKEARGS[@]}" \
		config="debug" \
		tess2
}

src_install() {
	doheader Include/tesselator.h
	doheader Contrib/nanosvg.h
	dolib.so Build/libtess2.so
	dodoc Example/example.c
	dodoc Contrib/nanosvg.c
	einstalldocs
}
