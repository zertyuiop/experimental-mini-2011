# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

DESCRIPTION="Reads FITS images and tables into numpy arrays and manipulates FITS headers"
HOMEPAGE="http://www.stsci.edu/institute/software_hardware/pyfits https://pypi.python.org/pypi/pyfits"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="$(python_abi_depend dev-python/numpy)
	$(python_abi_depend dev-python/setuptools)
	!dev-python/astropy"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/d2to1)
	$(python_abi_depend dev-python/stsci-distutils)"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-3.0.8-debundle_zlib.patch"
}

src_test() {
	python_execute_nosetests -e -P '$(ls -d build-${PYTHON_ABI}/lib.*)' -- -P '$(ls -d build-${PYTHON_ABI}/lib.*)'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/pyfits/tests"
	}
	python_execute_function -q delete_tests
}
