# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtbearer/qtbearer-4.8.5.ebuild,v 1.1 2013/07/09 10:49:12 pesa Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="The network bearer plugins for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
fi
IUSE="connman networkmanager"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	connman? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
	networkmanager? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

pkg_setup() {
	QT4_EXTRACT_DIRECTORIES="
		include/QtCore
		include/QtDBus
		include/QtNetwork
		src/corelib
		src/dbus
		src/network
		src/plugins/bearer
		src/plugins/qpluginbase.pri"

	QT4_TARGET_DIRECTORIES="
		src/plugins/bearer/generic
		$(use connman && echo src/plugins/bearer/connman)
		$(use networkmanager && echo src/plugins/bearer/networkmanager)"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		$(use connman || use networkmanager || echo -no-dbus)
		-no-accessibility -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon
		-no-phonon-backend -no-svg -no-webkit -no-script -no-scripttools -no-declarative
		-system-zlib -no-gif -no-libtiff -no-libpng -no-libmng -no-libjpeg
		-no-cups -no-gtkstyle -no-nas-sound -no-opengl
		-no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes
		-no-xrandr -no-xrender -no-mitshm -no-fontconfig -no-freetype -no-xinput -no-xkb"

	qt4-build_src_configure
}
