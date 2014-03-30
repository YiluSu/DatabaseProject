if [ -z "$CATALINA_BASE" ]; then
    echo "CATALINA_BASE environment variable is not set"
    exit 1
fi

rm -rf $CATALINA_BASE/webapps/proj
mkdir -p $CATALINA_BASE/webapps/proj/WEB-INF/lib
sh update.sh
cp /oracle/jdbc/lib/ojdbc5.jar $CATALINA_BASE/webapps/proj/WEB-INF/lib