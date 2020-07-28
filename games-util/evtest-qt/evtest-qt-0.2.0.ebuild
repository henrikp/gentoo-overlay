# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Joystick testing utility with a QT interface"
HOMEPAGE="https://github.com/Grumbel/evtest-qt/"
SRC_URI="https://github.com/Grumbel/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	# quick hack for the time being
	sed -i -e '/Terminal=false/d' evtest-qt.desktop
	echo 'Terminal=false' >> evtest-qt.desktop
	cmake_src_prepare
}

