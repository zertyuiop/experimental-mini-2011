# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/libidn/libidn-1.28.ebuild,v 1.1 2013/07/10 14:21:46 jer Exp $

EAPI=5

inherit elisp-common java-pkg-opt-2 mono-env

DESCRIPTION="Internationalized Domain Names (IDN) implementation"
HOMEPAGE="http://www.gnu.org/software/libidn/"
SRC_URI="mirror://gnu/libidn/${P}.tar.gz"

LICENSE="GPL-2 GPL-3 LGPL-3 java? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc emacs java mono nls static-libs"

DOCS=( AUTHORS ChangeLog FAQ NEWS README THANKS TODO )
COMMON_DEPEND="
	emacs? ( virtual/emacs )
	mono? ( >=dev-lang/mono-0.95 )
"
DEPEND="${COMMON_DEPEND}
	nls? ( >=sys-devel/gettext-0.17 )
	java? (
		>=virtual/jdk-1.5
		doc? ( dev-java/gjdoc )
	)
"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )
	java? ( >=virtual/jre-1.5 )
"

src_prepare() {
	# bundled, with wrong bytecode
	rm "${S}/java/${P}.jar" || die
}

src_configure() {
	econf \
		$(use_enable java) \
		$(use_enable mono csharp mono) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		--disable-silent-rules \
		--disable-valgrind-tests \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packager-bug-reports="https://bugs.gentoo.org" \
		--with-packager-version="r${PR}" \
		--with-packager="Gentoo"
}

src_compile() {
	default

	if use emacs; then
		elisp-compile src/*.el || die
	fi
}

src_install() {
	default

	if use emacs; then
		# *.el are installed by the build system
		elisp-install ${PN} src/*.elc
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el"
	else
		rm -r "${ED}/usr/share/emacs" || die
	fi

	if use doc ; then
		dohtml -r doc/reference/html/*
	fi

	if use java ; then
		java-pkg_newjar java/${P}.jar ${PN}.jar || die
		rm -r "${ED}"/usr/share/java || die

		if use doc ; then
			java-pkg_dojavadoc doc/java
		fi
	fi

	prune_libtool_files
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
