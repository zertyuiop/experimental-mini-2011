# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsndfile/libsndfile-1.0.25-r1.ebuild,v 1.1 2013/05/05 08:04:11 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
PYTHON_COMPAT=( python{2_5,2_6,2_7} pypy{1_9,2_0} )
inherit autotools-multilib flag-o-matic python-any-r1

MY_P=${P/_pre/pre}

DESCRIPTION="A C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.mega-nerd.com/libsndfile"
if [[ "${MY_P}" == "${P}" ]]; then
	SRC_URI="http://www.mega-nerd.com/libsndfile/files/${P}.tar.gz"
else
	SRC_URI="http://www.mega-nerd.com/tmp/${MY_P}b.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="alsa minimal sqlite static-libs test"

RDEPEND="
	!minimal? ( >=media-libs/flac-1.2.1[${MULTILIB_USEDEP}]
		>=media-libs/libogg-1.1.3[${MULTILIB_USEDEP}]
		>=media-libs/libvorbis-1.2.3[${MULTILIB_USEDEP}] )
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	sqlite? (
		>=dev-db/sqlite-3.2
		amd64? ( abi_x86_32? (
			app-emulation/emul-linux-x86-baselibs[development]
		) )
	)
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# fix adding largefile flags on amd64 multilib
	# https://github.com/erikd/libsndfile/commit/d464da7dba4d5
	sed -i -e 's:AC_SYS_EXTRA_LARGEFILE:AC_SYS_LARGEFILE:' configure.ac || die
	sed -i -e 's:noinst_PROGRAMS:check_PROGRAMS:' {examples,tests}/Makefile.am || die

	local PATCHES=(
		"${FILESDIR}"/${PN}-1.0.17-regtests-need-sqlite.patch
	)

	AT_M4DIR=M4 \
	autotools-multilib_src_prepare
	epunt_cxx
}

src_configure() {
	local myeconfargs=(
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html

		$(use_enable sqlite)
		$(use_enable static-libs static)
		$(use_enable alsa)
		$(use_enable !minimal external-libs)
		--disable-octave
		--disable-gcc-werror
		--disable-gcc-pipe
	)

	autotools-multilib_src_configure
}

src_install() {
	# note: --htmldir support fixed upstream already,
	# next version should pass --htmldir to configure instead
	autotools-multilib_src_install \
		htmldocdir=/usr/share/doc/${PF}/html
}
