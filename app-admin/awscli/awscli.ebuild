# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator

DESCRIPTION="These command-line tools serve as the client interface to the Amazon EC2 web service"
HOMEPAGE="https://docs.aws.amazon.com/cli/latest/userguide"
SRC_URI="https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/python"

src_prepare() {
  unzip awscli-bundle.zip
}

src_install() {
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
	dobin bin/*

	insinto /usr
	doins -r lib

	insinto /etc/ec2/amitools
	doins etc/ec2/amitools/*

	dodir /etc/env.d
	echo "EC2_AMITOOL_HOME=/usr" >> "${T}"/99${PN} || die "Can't write environment variable."
	doenvd "${T}"/99${PN}
}

pkg_postinst() {
	ewarn "Remember to run \`env-update && source /etc/profile\` if you plan"
	ewarn "to use these tools in a shell before logging out (or restarting"
	ewarn "your login manager)."
}
