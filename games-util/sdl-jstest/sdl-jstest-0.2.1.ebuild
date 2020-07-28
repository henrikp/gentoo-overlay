# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

MY_P="${PN}-v${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Joystick testing utilities for SDL and SDL2"
HOMEPAGE="https://gitlab.com/sdl-jstest/sdl-jstest"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${MY_P}.tar.gz"
EGIT_REPO_URI="https://github.com/gabomdq/SDL_GameControllerDB.git"
EGIT_CHECKOUT_DIR="${S}/SDL_GameControllerDB"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sdl +sdl2"

DEPEND=""
#DEPEND="media-libs/libsdl2
#		sys-libs/ncurses"
RDEPEND="${DEPEND}"
BDEPEND=""


src_unpack() { # see https://gitlab.com/sdl-jstest/sdl-jstest/-/merge_requests/12
	default
	git-r3_fetch
	git-r3_checkout
}

src_configure() {
		local mycmakeargs=(
			-DBUILD_SDL_JSTEST=$(usex sdl)
			-DBUILD_SDL2_JSTEST=$(usex sdl2)
			-DBUILD_SHARED_LIBS=ON
		)

		cmake_src_configure
}
