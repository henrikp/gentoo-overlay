# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qmake-utils git-r3

DESCRIPTION="Zeal is a simple documentation browser inspired by Dash"
HOMEPAGE="http://zealdocs.org/"
EGIT_REPO_URI="git://github.com/jkozera/zeal.git"
EGIT_BRANCH="master"
S="${WORKDIR}/zeal-9999/zeal"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libappindicator-12.10
	>=x11-libs/xcb-util-keysyms-0.3.9
	>=dev-libs/quazip-0.6.2-r1
	>=dev-qt/qtcore-5.4:5
	>=dev-qt/qtgui-5.4:5
	>=dev-qt/qtscript-5.4:5
	>=dev-qt/qtwidgets-5.4:5
	>=dev-qt/qtxml-5.4:5"
RDEPEND="${DEPEND}"

src_prepare() {
rm -rf quazip
epatch "${FILESDIR}/${PV}-library-fixes.patch" ..
}

src_configure() {
eqmake5
}

src_install() {
emake INSTALL_ROOT="${D}" install
}
