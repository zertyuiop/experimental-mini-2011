# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-1.8.5-r1.ebuild,v 1.24 2013/03/03 07:47:36 vapier Exp $

EAPI="3"
WANT_AUTOCONF="2.1"
inherit autotools eutils toolchain-funcs multilib python versionator pax-utils

MY_PN="js"
TARBALL_PV="$(replace_all_version_separators '' $(get_version_component_range 1-3))"
MY_P="${MY_PN}-${PV}"
TARBALL_P="${MY_PN}${TARBALL_PV}-1.0.0"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="https://ftp.mozilla.org/pub/mozilla.org/js/${TARBALL_P}.tar.gz"

LICENSE="NPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa -ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="debug static-libs test"

S="${WORKDIR}/${MY_P}"
BUILDDIR="${S}/js/src"

RDEPEND=">=dev-libs/nspr-4.7.0"
DEPEND="${RDEPEND}
	app-arch/zip
	=dev-lang/python-2*[threads]
	virtual/pkgconfig"

pkg_setup(){
	python_set_active_version 2

	export LC_ALL="C"
}

src_prepare() {
	# https://bugzilla.mozilla.org/show_bug.cgi?id=628723#c43
	epatch "${FILESDIR}/${P}-fix-install-symlinks.patch"
	# https://bugzilla.mozilla.org/show_bug.cgi?id=638056#c9
	epatch "${FILESDIR}/${P}-fix-ppc64.patch"
	# https://bugs.gentoo.org/show_bug.cgi?id=400727
	# https://bugs.gentoo.org/show_bug.cgi?id=420471
	epatch "${FILESDIR}/${P}-arm_respect_cflags-3.patch"
	# https://bugs.gentoo.org/show_bug.cgi?id=438746
	epatch "${FILESDIR}"/${PN}-1.8.7-freebsd-pthreads.patch
	# https://bugs.gentoo.org/show_bug.cgi?id=441928
	epatch "${FILESDIR}"/${PN}-1.8.5-perf_event-check.patch

	epatch_user

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -sfn "${BUILDDIR}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk"
	fi

	cd "${S}"/js/src
	eautoconf
}

src_configure() {
	cd "${BUILDDIR}"

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" PYTHON="$(PYTHON)" \
	econf \
		${myopts} \
		--enable-jemalloc \
		--enable-readline \
		--enable-threadsafe \
		--with-system-nspr \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_compile() {
	cd "${BUILDDIR}"
	if tc-is-cross-compiler; then
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			jscpucfg host_jsoplengen host_jskwgen || die
		make CFLAGS="" CXXFLAGS="" \
			CC=$(tc-getBUILD_CC) CXX=$(tc-getBUILD_CXX) \
			-C config nsinstall || die
		mv {,native-}jscpucfg
		mv {,native-}host_jskwgen
		mv {,native-}host_jsoplengen
		mv config/{,native-}nsinstall
		sed -e 's@./jscpucfg@./native-jscpucfg@' \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			-i Makefile
		sed -e 's@/nsinstall@/native-nsinstall@' -i config/config.mk
		rm config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o
	fi
	emake || die
}

src_test() {
	cd "${BUILDDIR}/jsapi-tests"
	emake check || die
}

src_install() {
	cd "${BUILDDIR}"
	emake DESTDIR="${D}" install || die
	dobin shell/js ||die
	pax-mark m "${ED}/usr/bin/js"
	dodoc ../../README || die
	dohtml README.html || die

	if ! use static-libs; then
		# We can't actually disable building of static libraries
		# They're used by the tests and in a few other places
		find "${D}" -iname '*.a' -delete || die
	fi
}
