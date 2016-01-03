EAPI="3"

DESCRIPTION="Linux Malware Detect (LMD) is a malware scanner for Linux"
HOMEPAGE="http://www.rfxn.com"
LICENSE="GPL-2"
SRC_URI="http://www.rfxn.com/downloads/maldetect-current.tar.gz"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

S="${WORKDIR}"
INSTALL_DIR="/usr/local/bin"

src_unpack() {
  unpack ${A}
}

src_install() {
  insinto ${INSTALL_DIR}
#  doins -r packer*
#  fperms 755 ${INSTALL_DIR}/packer*
}
