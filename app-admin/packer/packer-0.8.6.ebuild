EAPI="3"

DESCRIPTION="Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration"
HOMEPAGE="http://www.packer.io"
LICENSE="MIT"
SRC_URI="https://releases.hashicorp.com/packer/${PV}/packer_${PV}_linux_amd64.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

#RDEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}"
INSTALL_DIR="/usr/local/bin"

src_install() {
    insinto ${INSTALL_DIR}
	fperms 755 packer*
    doins -r packer*
}
