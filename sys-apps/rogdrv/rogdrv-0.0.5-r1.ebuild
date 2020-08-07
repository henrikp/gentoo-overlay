# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 linux-info udev

COMMIT="ab9c0316c8ab6ce954999c017f4d92b5cd5136cd"
DESCRIPTION="ASUS ROG userspace mouse driver for Linux."
HOMEPAGE="https://github.com/kyokenn/rogdrv"
S="${WORKDIR}/${PN}-${COMMIT}"
SRC_URI="https://github.com/kyokenn/${PN}/archive/${COMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/python-evdev[${PYTHON_USEDEP}]
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/hidapi[${PYTHON_USEDEP}]
		dev-libs/libappindicator
		virtual/udev"
RDEPEND="${DEPEND}"
CONFIG_CHECK="~INPUT_UINPUT"

python_prepare_all() {
	# udev rules are placed outside /usr
	sed -i -e '/etc[\/]udev/d' setup.py
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	udev_dorules udev/50-rogdrv.rules
}

pkg_postinst() {
	elog "Reconnect your mouse to get your mouse working with the new rules."
	elog "See the README file for usage instructions."
	udev_reload
}
