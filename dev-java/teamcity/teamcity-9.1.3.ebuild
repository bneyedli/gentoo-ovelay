EAPI="3"

inherit user

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://www.jetbrains.com/teamcity/"
LICENSE="MIT"
SRC_URI="http://download-cf.jetbrains.com/teamcity/TeamCity-${PV}.tar.gz"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/TeamCity"
INSTALL_DIR="/opt/teamcity"
RUN_DIR='/var/run/teamcity'
LOG_DIR='/var/log/teamcity'

QA_PRESTRIPPED="${INSTALL_DIR}/webapps/ROOT/WEB-INF/lib/libnet_sf_colorer.so"
QA_TEXTRELS="*"

pkg_setup() {
    enewgroup teamcity
    enewuser teamcity -1 /bin/bash /opt/teamcity teamcity
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.exe -or -name \*.bat -or -name \*.cmd \) -delete
    rm  buildAgent/launcher/lib/libwrapper-solaris-x86-32.so \
        buildAgent/launcher/lib/libwrapper-solaris-sparc-32.so \
        buildAgent/launcher/lib/libwrapper-solaris-sparc-64.so \
        buildAgent/launcher/bin/TeamCityAgentService-linux-x86-32 \
		buildAgent/launcher/lib/libwrapper-linux-x86-32.so \
        buildAgent/launcher/bin/TeamCityAgentService-solaris-sparc-64 \
        buildAgent/launcher/bin/TeamCityAgentService-solaris-sparc-32 \
        buildAgent/launcher/bin/TeamCityAgentService-linux-ppc-64 \
        buildAgent/launcher/lib/libwrapper-linux-ppc-64.so \
        buildAgent/launcher/bin/TeamCityAgentService-solaris-x86-32
	dodir ${RUN_DIR} ${LOG_DIR}
	fowners -R teamcity:teamcity ${RUN_DIR} ${LOG_DIR}
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r Tomcat-running.txt bin buildAgent conf devPackage lib licenses temp webapps
	dodoc TeamCity-readme.txt Tomcat-running.txt

    newinitd "${FILESDIR}/server.sh" teamcity-server
    newinitd "${FILESDIR}/agent.sh" teamcity-agent
    newconfd "${FILESDIR}/conf" teamcity

    fowners -R teamcity:teamcity "${INSTALL_DIR}"

	find ${INSTALL_DIR} -name "*.sh" -exec fperms 755 {} \;

    # Protect teamcity conf on upgrade
    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/conf ${INSTALL_DIR}/buildAgent/conf\"" > "${T}/25teamcity" || die
    doenvd "${T}/25teamcity"
}
