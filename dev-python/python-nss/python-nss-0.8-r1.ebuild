# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-nss/python-nss-0.8-r1.ebuild,v 1.1 2011/10/31 20:01:46 maksbotan Exp $

EAPI="3"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Python bindings for Network Security Services (NSS)"
HOMEPAGE="http://people.redhat.com/jdennis/python-nss/doc/api/html"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.lzma"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-libs/nss
	dev-libs/nspr
	doc? ( dev-python/docutils
			dev-python/epydoc )"

RDEPEND="${DEPEND}"

DOCS="README doc/ChangeLog"

src_prepare() {
	epatch "${FILESDIR}"/*.patch
}

src_install() {
	distutils_src_install

	if use doc; then
		einfo "Generating API documentation..."

		mkdir "${S}"/doc/html
		PYTHONPATH="${ED}$(python_get_sitedir -f)" epydoc --html --docformat restructuredtext \
			-o "${S}"/doc/html \
			 "$(ls -d build-$(PYTHON -f --ABI)/lib.*)/nss"

		dohtml -r "${S}"/doc/html/
		insinto /usr/share/doc/"${PF}"
		doins -r ./test
		insinto /usr/share/doc/"${PF}"/examples
		doins doc/examples/*.py
	fi
}