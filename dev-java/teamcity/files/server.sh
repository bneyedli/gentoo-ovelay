#!/sbin/runscript

depend() {
    need net
}

. /etc/conf.d/teamcity

CATALINA_HOME=${TEAMCITY_HOME}
CATALINA_BASE=${TEAMCITY_HOME}
BIN=${TEAMCITY_HOME}/bin
CONF=${TEAMCITY_HOME}/conf

RUN_AS=teamcity

checkconfig() {
    ${BIN}/catalina.sh configtest &> /dev/null
    return $?
}

if [ -f "$BIN/teamcity-init.sh" ]; then
  . "$BIN/teamcity-init.sh"
fi

if [ "$TEAMCITY_SERVER_MEM_OPTS" = "" ]; then
  TEAMCITY_SERVER_MEM_OPTS="-Xms750m -Xmx750m -XX:MaxPermSize=270m"
fi

CATALINA_OPTS="$CATALINA_OPTS $TEAMCITY_SERVER_OPTS -server $TEAMCITY_SERVER_MEM_OPTS -Dteamcity.configuration.path=\"${CONF}/teamcity-startup.properties\" -Dlog4j.configuration=\"file:${CONF}/teamcity-server-log4j.xml\" -Dteamcity_logs=$TEAMCITY_LOG_PATH -Djsse.enableSNIExtension=false -Djava.awt.headless=true"

if [ ! "$TEAMCITY_DATA_PATH" = "" ]; then
  CATALINA_OPTS="$CATALINA_OPTS -Dteamcity.data.path=$TEAMCITY_DATA_PATH"
fi

export CATALINA_OPTS

if [ "$TEAMCITY_PREPARE_SCRIPT" != "" ]; then
    "$TEAMCITY_PREPARE_SCRIPT" $*
fi

export CATALINA_PID="$TEAMCITY_PID_FILE_PATH"

start() {
    checkconfig || return 1

    ebegin "Starting ${SVCNAME}"

    su $RUN_AS -c "${BIN}/catalina.sh start" &> /dev/null
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"

    su $RUN_AS -c "${BIN}/catalina.sh stop" &> /dev/null
    eend $?
}
