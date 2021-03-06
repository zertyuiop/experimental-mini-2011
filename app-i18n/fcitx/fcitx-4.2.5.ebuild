# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx/fcitx-4.2.5.ebuild,v 1.4 2013/04/21 10:04:51 lxnay Exp $

EAPI=4

inherit multilib cmake-utils gnome2-utils eutils

DESCRIPTION="An input method framework with extension support"
HOMEPAGE="http://www.fcitx.org/"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.xz
		http://fcitx.googlecode.com/files/pinyin.tar.gz
		table? ( http://fcitx.googlecode.com/files/table.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cairo debug gtk gtk3 introspection lua opencc +pango qt4 snooper static-libs +table test"

RDEPEND="
	cairo? (
		x11-libs/cairo[X]
		pango? ( x11-libs/pango[X] )
		!pango? ( media-libs/fontconfig )
	)
	gtk? (
		x11-libs/gtk+:2
		dev-libs/glib:2
		dev-libs/dbus-glib
	)
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/glib:2
		dev-libs/dbus-glib
	)
	introspection? ( dev-libs/gobject-introspection )
	lua? ( dev-lang/lua )
	opencc? ( app-i18n/opencc )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtdbus:4
	)
	sys-apps/dbus
	x11-libs/libX11"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	app-text/enchant
	app-text/iso-codes
	dev-libs/icu
	dev-util/intltool
	virtual/pkgconfig
	x11-libs/libxkbfile
	x11-proto/xproto"

src_prepare() {
	cp "${DISTDIR}/pinyin.tar.gz" "${S}/data" || die "pinyin.tar.gz is not found"
	if use table ; then
		cp "${DISTDIR}/table.tar.gz" "${S}/data/table" || die "table.tar.gz is not found"
	fi
}

src_configure() {
	local mycmakeargs="
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		$(cmake-utils_use_enable cairo CARIO)
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable gtk GTK2_IM_MODULE)
		$(cmake-utils_use_enable gtk3 GTK3_IM_MODULE)
		$(cmake-utils_use_enable introspection GIR)
		$(cmake-utils_use_enable lua LUA)
		$(cmake-utils_use_enable opencc OPENCC)
		$(cmake-utils_use_enable pango PANGO)
		$(cmake-utils_use_enable qt4 QT_IM_MODULE)
		$(cmake-utils_use_enable snooper SNOOPER)
		$(cmake-utils_use_enable static-libs STATIC)
		$(cmake-utils_use_enable table TABLE)
		$(cmake-utils_use_enable test TEST)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/doc/${PN} || die
	dodoc AUTHORS ChangeLog README THANKS TODO doc/pinyin.txt doc/cjkvinput.txt
	dohtml doc/wb_fh.htm
}

pkg_postinst() {
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
	elog
	elog "You should export the following variables to use fcitx:"
	elog "  export XMODIFIERS=\"@im=fcitx\""
	elog "  export XIM=fcitx"
	elog "  export XIM_PROGRAM=fcitx"
	elog
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
	use gtk3 && gnome2_query_immodules_gtk3
}
