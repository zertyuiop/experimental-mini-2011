# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"

inherit mate virtualx

DESCRIPTION="The MATE Canvas library"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc glade"

RDEPEND=">=dev-libs/glib-2.10:2
	x11-libs/gtk+:2
	>=media-libs/libart_lgpl-2.3.8
	>=x11-libs/pango-1.0.1
	glade? ( >=gnome-base/libglade-2:2.0 )"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=dev-util/gtk-doc-1"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF} $(use_enable glade)"
}

src_prepare() {
	mate_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"

	# Don't build demos that are not even installed, bug #226299
	sed 's/^\(SUBDIRS =.*\)demos\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
		|| die "sed 2 failed"
}

src_test() {
	Xemake check || die "Test phase failed"
}
