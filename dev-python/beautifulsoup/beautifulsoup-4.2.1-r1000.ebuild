# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="beautifulsoup4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Beautiful Soup is a Python library for pulling data out of HTML and XML files"
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/ https://launchpad.net/beautifulsoup https://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="http://www.crummy.com/software/BeautifulSoup/bs4/download/4.2/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="*"
IUSE="doc html5lib +lxml"

RDEPEND="html5lib? ( $(python_abi_depend -e "*-jython" dev-python/html5lib) )
	lxml? ( $(python_abi_depend -e "*-jython *-pypy-*" dev-python/lxml) )"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS.txt NEWS.txt README.txt TODO.txt"
PYTHON_MODULES="bs4"

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	einfo "Testing with enabled html5lib and enabled lxml"
	python_execute_nosetests -e -P 'build-${PYTHON_ABI}/lib' -- -P -w 'build-${PYTHON_ABI}/lib'

	einfo "Testing with disabled html5lib and disabled lxml"
	echo "raise ImportError" > "${T}/html5lib.py"
	echo "raise ImportError" > "${T}/lxml.py"
	python_execute_nosetests -e -P '${T}:build-${PYTHON_ABI}/lib' -- -P -w 'build-${PYTHON_ABI}/lib'
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -fr "${ED}$(python_get_sitedir)/bs4/"{testing.py,tests}
	}
	python_execute_function -q delete_tests

	if use doc; then
		dohtml -r doc/build/html/
	fi
}
