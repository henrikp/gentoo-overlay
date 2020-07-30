# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

COMMIT="5d1d5f888ff1d222dffd931aea5828f62d1c4c48"
DESCRIPTION="Simple web interface to manage VBAN."
HOMEPAGE="https://github.com/VBAN-manager/VBAN-manager"
MY_PN="VBAN-manager"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${COMMIT}.zip -> ${PF}.zip"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

