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
IUSE="examples contrib"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-util/premake:4"

src_prepare() {
	sed -i \
		-e "s/StaticLib/SharedLib/" \
		"${S}"/premake4.lua || die "Unable to apply patch!"
	premake4 gmake
	sed -i \
		-e "s/+= \$(LDDEPS)/+= \$(LDDEPS) -Wl,-soname,libtess2.so/" \
		"${S}"/Build/tess2.make || die "Unable to apply patch!"
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
		config=debug \
		tess2
}

src_install() {
	doheader ${S}/Include/tesselator.h
	dolib.so ${S}/Build/libtess2.so
}
