if [ -z "$CATALINA_BASE" ]; then
    echo "CATALINA_BASE environment variable is not set"
    exit 1
fi

rsync -avh proj/* $CATALINA_BASE/webapps/proj 



