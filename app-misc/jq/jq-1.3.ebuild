# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jq/jq-1.3.ebuild,v 1.4 2013/07/04 12:24:59 ago Exp $

EAPI=5

inherit autotools

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="http://stedolan.github.com/jq/"
SRC_URI="http://stedolan.github.io/jq/download/source/${P}.tar.gz"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="sys-devel/bison
	sys-devel/flex
	test? ( dev-util/valgrind )"

DOCS=( AUTHORS README )

src_prepare() {
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	# don't try to rebuild docs
	econf --disable-docs
}
