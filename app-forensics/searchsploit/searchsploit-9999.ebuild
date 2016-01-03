# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

GIT_ECLASS="git-r3"
EGIT_REPO_URI="git://github.com/offensive-security/exploit-database.git"

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="Exploit Database is a repository for exploits and proof-of-concepts rather than advisories, making it a valuable resource for those who need actionable data right away."
HOMEPAGE="https://www.exploit-db.com/"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL2"
SLOT="0"

#src_compile() {
#}

#src_install() {
#}

pkg_postinst() {
	elog "Recommended packages: net-misc/wget and media-video/mplayer"
	elog
}
