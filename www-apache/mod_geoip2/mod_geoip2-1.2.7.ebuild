# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_geoip2/mod_geoip2-1.2.7.ebuild,v 1.2 2012/10/12 09:27:15 patrick Exp $

inherit apache-module

MY_P="${PN}_${PV}"
MY_PN="${PN/2}"

DESCRIPTION="Apache 2.x module for finding the country and city
that a web request originated from"
HOMEPAGE="http://www.maxmind.com/app/mod_geoip"
SRC_URI="http://geolite.maxmind.com/download/geoip/api/mod_geoip2/${MY_P}.tar.gz"
LICENSE="Apache-1.1"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND=">=dev-libs/geoip-1.4.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="30_${PN}"
APACHE2_MOD_FILE="${S}/.libs/${MY_PN}.so"
APXS2_ARGS="-l GeoIP -c ${MY_PN}.c"
DOCFILES="INSTALL README README.php Changes"

need_apache2_2
