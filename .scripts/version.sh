#!/usr/bin/env bash

NEW_APP_VERSION=$(cat package.json | jase NEW_APP_VERSION)

type=$1
exitstatus=0

if [ -f $type ] ; then
    NEW_APP_VERSION=$(node ./.scripts/incNEW_APP_VERSION.js -v $NEW_APP_VERSION || exitstatus=$?);
else
    if [[ $type == "minor" || $type == "major" || $type == "patch" ]] ; then
        NEW_APP_VERSION=$(node ./.scripts/incNEW_APP_VERSION.js -v $NEW_APP_VERSION --$type || exitstatus=$?);
    fi
fi

if [ -f $NEW_APP_VERSION ] ; then
    echo "no NEW_APP_VERSION found";
elif [ $exitstatus -ne 1 ]; then
    # back up current
    cat package.json > package.old.json
    # change current NEW_APP_VERSION
    result=$(cat package.json | jase NEW_APP_VERSION -s $NEW_APP_VERSION > package2.json);
    # replace with new one
    mv package2.json package.json;
elif [$exitstatus -ne 0]; then
    break;
    exit $exitstatus
fi
