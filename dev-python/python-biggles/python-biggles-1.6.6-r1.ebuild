# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-biggles/python-biggles-1.6.6-r1.ebuild,v 1.1 2013/06/13 06:44:27 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

MY_PN="python2-biggles"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python module for creating publication-quality 2D scientific plots"
HOMEPAGE="http://biggles.sourceforge.net/"
SRC_URI="mirror://sourceforge/biggles/${MY_P}.tar.gz"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/plotutils[X]
	x11-libs/libSM
	x11-libs/libXext"
RDEPEND="${DEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/${PN}/
	doins -r examples
}
