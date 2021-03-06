# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-trident/xf86-video-trident-1.3.6-r2.ebuild,v 1.1 2013/03/12 16:37:59 chithanh Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Trident video driver"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-no-xaa.patch
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
