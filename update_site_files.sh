#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of args; should be 1"
fi

if [ "$1" = "vps" ]; then
    LAST_SHA_FILE=/home/ryan/cuddly_broccoli_sha
else
    echo "unrecognized argument"
    return 1
fi


HEAD_SHA=$( curl -s https://api.github.com/repos/ryanthomastech/cuddly-broccoli/commits/main -H "Accept: application/vnd.github.v3.sha+json")

if [ ! -f "$LAST_SHA_FILE" ]; then
    touch $LAST_SHA_FILE
fi

LAST_SHA=$( cat $LAST_SHA_FILE )

if [ $LAST_SHA = $HEAD_SHA ]; then
    echo "they match"
    return 0
else
    echo "no match here"
    echo $HEAD_SHA | tee $LAST_SHA_FILE >/dev/null
fi

