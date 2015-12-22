#!/sbin/runscript

depend() {
    need net
}

RUN_AS=teamcity

checkconfig() {
    return 0
}

start() {
    checkconfig || return 1

    ebegin "Starting ${SVCNAME}"

    . /etc/conf.d/teamcity
    su $RUN_AS -c "cd ${TEAMCITY_AGENT_PATH}/bin && /bin/sh ./agent.sh start" &> /dev/null
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"

    . /etc/conf.d/teamcity
    su $RUN_AS -c "cd ${TEAMCITY_AGENT_PATH}/bin && /bin/sh ./agent.sh stop" &> /dev/null
    eend $?
}
