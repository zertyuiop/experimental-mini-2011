# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/pgcedit/pgcedit-0.8.6.ebuild,v 1.1 2012/12/31 00:46:07 vapier Exp $

EAPI="4"

inherit eutils versionator

MY_PN="PgcEdit"
MY_P="${MY_PN}_source_$(get_after_major_version)"
MY_PDOC="${MY_PN}_Manual_html"

DESCRIPTION="DVD IFO and Menu editor"
HOMEPAGE="http://download.videohelp.com/r0lZ/pgcedit/"
SRC_URI="http://download.videohelp.com/r0lZ/${PN}/versions/${MY_P}.zip
	http://download.videohelp.com/r0lZ/${PN}/versions/${MY_PDOC}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="video"

RDEPEND="app-cdr/cdrtools
	>=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	video? ( app-emulation/wine )"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-config-paths.patch
	sed -i "s:@DOCDIR@:/usr/share/doc/${PF}/html:" lib/main.tcl || die
	# These are only used in Windows.
	rm bin/{mkisofs,pskill}.exe || die
	use video || rm bin/PgcEditPreview.exe
}

src_install() {
	newbin ${MY_PN}_main.tcl ${PN}

	keepdir /usr/share/${PN}/plugins
	insinto /usr/share/${PN}
	doins -r bin lib
	dohtml -r doc/*

	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry ${PN} ${MY_PN} ${PN} "AudioVideo;Video;"

	dodoc HISTORY.txt TODO.txt
}
