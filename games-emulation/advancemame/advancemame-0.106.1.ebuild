# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/advancemame/advancemame-0.106.1.ebuild,v 1.2 2009/11/21 17:59:37 maekke Exp $

EAPI=2
inherit eutils flag-o-matic games

DESCRIPTION="GNU/Linux port of the MAME emulator with GUI menu"
HOMEPAGE="http://advancemame.sourceforge.net/"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

LICENSE="GPL-2 XMAME"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="alsa fbcon oss sdl static svga truetype"

# sdl is required (bug #158417)
RDEPEND="app-arch/unzip
	app-arch/zip
	media-libs/libsdl
	dev-libs/expat
	alsa? ( media-libs/alsa-lib )
	truetype? ( media-libs/freetype )
	svga? ( >=media-libs/svgalib-1.9 )"
DEPEND="${RDEPEND}
	x86? ( >=dev-lang/nasm-0.98 )
	virtual/os-headers"

src_prepare() {
	epatch "${FILESDIR}/${P}-pic.patch"
	sed -i \
		-e 's/"-s"//' \
		configure \
		|| die "sed failed"

	use x86 && \
		ln -s $(type -P nasm) "${T}/${CHOST}-nasm"
	ln -s $(type -P sdl-config) "${T}/${CHOST}-sdl-config"
	use truetype && \
		ln -s $(type -P freetype-config) "${T}/${CHOST}-freetype-config"
}

src_configure() {
	# Fix for bug #78030
	if use ppc; then
		append-ldflags "-Wl,--relax"
	fi

	PATH="${PATH}:${T}"
	egamesconf \
		--enable-expat \
		--enable-sdl \
		--enable-zlib \
		--disable-slang \
		$(use_enable alsa) \
		$(use_enable fbcon fb) \
		$(use_enable oss) \
		$(use_enable static) \
		$(use_enable svga svgalib) \
		$(use_enable truetype freetype) \
		$(use_enable x86 asm) \
		--with-emu=${PN/advance}
}

src_compile() {
	STRIPPROG=true emake || die "emake failed"
}

src_install() {
	local f

	for f in adv* ; do
		if [[ -L "${f}" ]] ; then
			dogamesbin "${f}" || die "dogamesbin failed"
		fi
	done

	insinto "${GAMES_DATADIR}/advance"
	doins support/event.dat
	keepdir "${GAMES_DATADIR}/advance/"{artwork,diff,image,rom,sample,snap}

	dodoc HISTORY README RELEASE
	cd doc
	dodoc *.txt
	dohtml *.html
	for f in *.1 ; do
		newman ${f} ${f/1/6}
	done

	prepgamesdirs
}
