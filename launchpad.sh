#!/bin/bash

LAUNCHPAD_DB=`ls ~/Library/Application\\ Support/Dock/*.db`
TESTMODE_ECHO_ONLY=false

#remove apps from launchpad database
launchpad_rm() {
    case $# in
        2)  TABLE=$1
            QUALIFIER="WHERE title='$2'"
            ;;
        *)  echo "usage: launchpad_rm <table> <entry titel>"
            return
            ;;
    esac

    SQL_STATEMENT="DELETE FROM $TABLE $QUALIFIER;"

    if $TESTMODE_ECHO_ONLY; then
        echo "sqlite3 $LAUNCHPAD_DB \"$SQL_STATEMENT\" && killall Dock"
    else
        sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT" && killall Dock
    fi
}

#list apps in launchpad database
launchpad_ls() {
    case $# in
        1)  TABLE=$1
            FIELDS=*
            QUALIFIER=""
            ;;
        2)  TABLE=$1
            FIELDS=*
            QUALIFIER="WHERE title LIKE '$2%'"
            ;;
        *) return
            ;;
    esac

    SQL_STATEMENT="SELECT $FIELDS FROM $TABLE $QUALIFIER;"

    if $TESTMODE_ECHO_ONLY ; then
        echo "sqlite3 $LAUNCHPAD_DB \"$SQL_STATEMENT\""
    else
        sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT"
    fi
}

#display launchpad database information
launchpad_info() {
    case $# in
        0)  TABLE="sqlite_master"
            FIELDS="type, name, rootpage"
            QUALIFIER=""
            SQL_STATEMENT="SELECT $FIELDS FROM $TABLE $QUALIFIER;"
            ;; 
        1)  TABLE=$1
            SQL_STATEMENT="PRAGMA table_info($TABLE);"
            ;;
    esac

    if $TESTMODE_ECHO_ONLY; then
        echo "sqlite3 $LAUNCHPAD_DB $SQL_STATEMENT"
    else
        sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT"
    fi
        
}

