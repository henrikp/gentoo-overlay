# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

COMMIT="6a7c28d583c5a7707010af8203f91a3680794ee8"
DESCRIPTION="Simple web interface to manage VBAN."
HOMEPAGE="https://github.com/VBAN-manager/VBAN-manager"
MY_PN="VBAN-manager"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${COMMIT}.zip -> ${PF}.zip"
S="${WORKDIR}/${MY_PN}-${COMMIT}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
