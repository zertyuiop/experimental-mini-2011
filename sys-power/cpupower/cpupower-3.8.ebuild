# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpupower/cpupower-3.8.ebuild,v 1.3 2013/04/23 03:23:12 patrick Exp $

EAPI=5
inherit multilib toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="mirror://kernel/linux/kernel/v3.x/linux-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpufreq_bench debug nls"

# cpupower should be a USE flag in linux-misc-apps (ditto for usbip!)
# but only if the maintainer doesn't agree to drop it completely from
# there in favour of this one which i'll push to users are replacement
# for the dead cpufreq tools in tree
# !sys-apps/linux-misc-apps[cpupower]

# header collision with cpufrequtils
RDEPEND="sys-apps/pciutils
	!sys-apps/linux-misc-apps
	!sys-power/cpufrequtils"
DEPEND="${RDEPEND}
	virtual/os-headers
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/linux-${PV}/tools/power/${PN}

pkg_setup() {
	myemakeargs=(
		DEBUG=$(usex debug true false)
		V=1
		CPUFREQ_BENCH=$(usex cpufreq_bench true false)
		NLS=$(usex nls true false)
		docdir=/usr/share/doc/${PF}/${PN}
		mandir=/usr/share/man
		libdir=/usr/$(get_libdir)
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		STRIP=true
		LDFLAGS="${LDFLAGS}"
		OPTIMIZATION="${CFLAGS}"
		)
}

src_prepare() {
	# -Wl,--as-needed compat
	local libs="-lcpupower -lrt -lpci"
	sed -i \
		-e "/$libs/{ s,${libs},,g; s,\$, ${libs},g;}" \
		-e "s:-O1 -g::" \
		Makefile || die
}

src_compile() {
	emake "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${myemakeargs[@]}" install
	dodoc README ToDo

	newconfd "${FILESDIR}"/conf.d ${PN}
	newinitd "${FILESDIR}"/init.d ${PN}
}
