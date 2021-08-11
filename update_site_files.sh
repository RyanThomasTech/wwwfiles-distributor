#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of args; should be 1"
fi

if [ "$1" = "vps" ]; then
    LAST_SHA_FILE=/var/lib/cuddly_broccoli_sha
else
    echo "unrecognized argument"
    exit 1
fi


HEAD_SHA=$( curl -s https://api.github.com/repos/ryanthomastech/cuddly-broccoli/commits/main -H "Accept: application/vnd.github.v3.sha+json")

if [ ! -f "$LAST_SHA_FILE" ]; then
    touch $LAST_SHA_FILE
fi

LAST_SHA=$( cat $LAST_SHA_FILE )

if [ $LAST_SHA = $HEAD_SHA ]; then
    exit 0
else
    echo $HEAD_SHA | tee $LAST_SHA_FILE >/dev/null
#TODO: consider separating removal of old files to be dependent upon success of getting new ones
    if [ -d /etc/nginx/sites-available/cuddly-broccoli ]; then
        rm -r /etc/nginx/sites-available/cuddly-broccoli
    fi
    git clone https://github.com/RyanThomasTech/cuddly-broccoli /tmp/sitefiles/cuddly-broccoli
    mv /tmp/sitefiles/cuddly-broccoli/$1 /etc/nginx/sites-available/cuddly-broccoli
    rm -r /tmp/sitefiles/cuddly-broccoli
    if [ ! -f /etc/nginx/sites-enabled/cuddly-broccoli ]; then
        ln -s /etc/nginx/sites-available/cuddly-broccoli /etc/nginx/sites-enabled/cuddly-broccoli
    fi
fi
exit 0
