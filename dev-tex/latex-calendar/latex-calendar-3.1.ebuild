# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex-calendar/latex-calendar-3.1.ebuild,v 1.8 2013/04/03 22:23:08 ulm Exp $

inherit latex-package

MY_P="calendar"
DESCRIPTION="LaTeX package used to create Calendars.  Very flexible and robust."
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/calendar/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LaTeX-Calendar"
SLOT="0"
KEYWORDS="x86 sparc ppc amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	debug-print function $FUNCNAME $*
	echo "Extracting from allcal.ins"
	( yes | latex allcal.ins ) >/dev/null 2>&1
}

src_install() {
	texi2dvi -q -c --language=latex calguide.tex &> /dev/null
	latex-package_src_doinstall styles fonts bin dvi
	dodoc README MANIFEST CATALOG
	insinto /usr/share/doc/${P}/samples
	doins bigdemo.tgz *.cfg *.tex *.cld
}
