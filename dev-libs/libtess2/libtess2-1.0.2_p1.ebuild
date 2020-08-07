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
IUSE="static-libs"
DOCS=( README.md )

DEPEND="media-libs/glew:0"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/premake:4"

PATCHES=( "${FILESDIR}"/libtess2-1.0.2_p1-premake-edit.patch )

src_prepare() {
	default
	premake4 gmake
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
		tess2 tess2shared
}

src_install() {
	doheader Include/tesselator.h
	doheader Contrib/nanosvg.h
	dolib.so Build/libtess2.so
	use static-libs && dolib.a Build/libtess2.a
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}"/libtess2.pc
	dodoc Example/example.c
	dodoc Contrib/nanosvg.c
	docompress -x /usr/share/doc/${P}
}
