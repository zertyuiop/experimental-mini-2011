# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korganizer/korganizer-4.4.11.1.ebuild,v 1.9 2013/05/31 15:26:51 kensington Exp $

EAPI=4

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A Personal Organizer for KDE"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)' 4.6)
	$(add_kdebase_dep libkdepim)
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep ktimezoned)
"

# Moved after 4.3.90
add_blocker kontact-specialdates

KMLOADLIBS="libkdepim"
KMEXTRA="kdgantt1"

# xml targets from kmail are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kmail/
	knode/org.kde.knode.xml
"

# bug 378151
RESTRICT=test

src_unpack() {
	if use kontact; then
		KMEXTRA="${KMEXTRA}
			kontact/plugins/planner/
			kontact/plugins/specialdates/
		"
	fi

	kde4-meta_src_unpack
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
}
