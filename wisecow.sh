#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
        read line
        echo $line
}

handleRequest() {
    # Process the request
        get_api
        mod=`fortune`

cat <<EOF > $RSPFILE
HTTP/1.1 200

<pre>`cowsay $mod`</pre>
EOF
}

prerequisites() {
    echo "Checking prerequisites..."
    export PATH=$PATH:/usr/games
    echo "PATH is: $PATH"
    echo "Fortune is at: $(which fortune)"
    echo "Cowsay is at: $(which cowsay)"
    echo "NC is at: $(which nc)"

    if ! command -v cowsay >/dev/null 2>&1; then
        echo "cowsay not found"
    fi
    if ! command -v fortune >/dev/null 2>&1; then
        echo "fortune not found"
    fi
    if ! command -v nc >/dev/null 2>&1; then
        echo "nc not found"
    fi

    command -v cowsay >/dev/null 2>&1 && \
    command -v fortune >/dev/null 2>&1 && \
    command -v nc >/dev/null 2>&1 || { 
        echo "Install prerequisites."
        exit 1
    }
}

main() {
        prerequisites
        echo "Wisdom served on port=$SRVPORT..."

        while [ 1 ]; do
                cat $RSPFILE | nc -lN $SRVPORT | handleRequest
                sleep 0.01
        done
}

main
