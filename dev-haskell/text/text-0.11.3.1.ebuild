# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/text/text-0.11.3.1.ebuild,v 1.1 2013/05/25 13:26:14 gienah Exp $

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="An efficient packed Unicode text type."
HOMEPAGE="https://github.com/bos/text"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="developer integer-simple"

RDEPEND=">=dev-haskell/deepseq-1.1.0.0:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8
		test? ( >=dev-haskell/hunit-1.2
			>=dev-haskell/quickcheck-2.4
			dev-haskell/random
			>=dev-haskell/test-framework-0.4
			>=dev-haskell/test-framework-hunit-0.2
			>=dev-haskell/test-framework-quickcheck2-0.2
		)"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag developer developer) \
		$(cabal_flag integer-simple integer-simple)
}
