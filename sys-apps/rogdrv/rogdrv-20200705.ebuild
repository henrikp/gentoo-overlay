# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2



EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit linux-info git-r3 udev python-single-r1

DESCRIPTION="ASUS ROG userspace mouse driver for Linux."
HOMEPAGE="https://github.com/kyokenn/rogdrv"
EGIT_REPO_URI="https://github.com/kyokenn/rogdrv.git"
EGIT_COMMIT="4bdb41403d2000ae8941bc987f5a2dbafedbc544"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
		dev-libs/libappindicator
		dev-python/python-evdev
		dev-python/cffi
		dev-python/cython-hidapi
		virtual/udev"
RDEPEND="${DEPEND}"
BDEPEND=""
CONFIG_CHECK="~INPUT_UINPUT"

src_prepare() {
	default
}

#src_compile() {
#	python-single-r1_pkg_setup
#}

src_install() {
	# ${PYTHON} setup.py install
	udev_dorules udev/50-rogdrv.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
}
