# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="The Command Line Interface (CLI) to bundle an Amazon Machine Image (AMI), create an AMI from an existing machine or installed volume, and upload a bundled AMI to Amazon S3."
HOMEPAGE="https://aws.amazon.com/developertools/368"
SRC_URI="http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-${PV}.zip"

S="${WORKDIR}/ec2-ami-tools-${PV}"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-arch/unzip"
RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/ec2-ami-tools-${PV}"
}

src_install() {
	dodir /opt/${PN}
	insinto /opt/${PN}/lib
	doins -r "${S}"/lib/*
	exeinto /opt/${PN}/bin
	doexe "${S}"/bin/*

	dodir /etc/env.d
	cat - > "${T}"/99${PN} <<EOF
AWS_IAM_HOME=/opt/${PN}
PATH=/opt/${PN}/bin
ROOTPATH=/opt/${PN}/bin
EOF
	doenvd "${T}"/99${PN}

	dodoc "licence.txt" "notice.txt" "readme-install.txt"
}

pkg_postinst() {
	ewarn "Remember to run: env-update && source /etc/profile if you plan"
	ewarn "to use these tools in a shell before logging out (or restarting"
	ewarn "your login manager)"
	elog
	elog "You need to put the following in your ~/.bashrc replacing the"
	elog "values with the full path to your AWS credentials file."
	elog
	elog "  export AWS_CREDENTIAL_FILE=/path/and_filename_of_credential_file"
	elog
	elog "It should contains two lines: the first line lists the AWS Account's"
	elog "AWS Access Key ID, and the second line lists the AWS Account's"
	elog "Secret Access Key. For example:"
	elog
	elog "  AWSAccessKeyId="
	elog "  AWSSecretKey="
}
