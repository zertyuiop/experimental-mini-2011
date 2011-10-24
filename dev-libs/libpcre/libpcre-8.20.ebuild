# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpcre/libpcre-8.20.ebuild,v 1.1 2011/10/23 16:06:55 flameeyes Exp $

EAPI="4"

inherit libtool eutils toolchain-funcs flag-o-matic

DESCRIPTION="Perl-compatible regular expression library"
HOMEPAGE="http://www.pcre.org/"
MY_P="pcre-${PV/_rc/-RC}"
if [[ ${PV} != *_rc* ]] ; then
	# Only the final releases are available here.
	SRC_URI="mirror://sourceforge/pcre/${MY_P}.tar.bz2
		ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${MY_P}.tar.bz2"
else
	SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/Testing/${MY_P}.tar.bz2"
fi

LICENSE="BSD"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 +cxx +jit +readline +recursion-limit static-libs unicode zlib"

RDEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	userland_GNU? ( >=sys-apps/findutils-4.4.0 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e "s:-lpcre ::" libpcrecpp.pc.in || die
	elibtoolize
}

src_configure() {
	[[ ${CHOST} == *-mint* ]] && append-flags -D_GNU_SOURCE
	econf \
		--with-match-limit-recursion=$(use recursion-limit && echo 8192 || echo MATCH_LIMIT) \
		$(use_enable unicode utf8) $(use_enable unicode unicode-properties) \
		$(use_enable cxx cpp) \
		$(use_enable zlib pcregrep-libz) \
		$(use_enable bzip2 pcregrep-libbz2) \
		$(use_enable static-libs static) \
		$(use_enable jit) $(use_enable jit pcregrep-jit) \
		$(use_enable readline pcretest-readline) \
		--enable-shared \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install
	gen_usr_ldscript -a pcre
	find "${D}" -type f -name '*.la' -exec rm -f {} +
}