# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/time/time-1.7-r1.ebuild,v 1.7 2012/06/03 23:28:04 vapier Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="displays info about resources used by a program"
HOMEPAGE="http://www.gnu.org/directory/time.html"
SRC_URI="mirror://gnu/time/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${PV}-info-dir-entry.patch
	eautoreconf
}
