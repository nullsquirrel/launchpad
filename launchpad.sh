#!/bin/bash

LAUNCHPAD_DB=`ls ~/Library/Application\\ Support/Dock/*.db`

#remove apps from launch pad
launchpad_rm() {
    case $# in
        0) return
            ;;
        1) return
            ;;
        2) TABLE=$1
            QUALIFIER="WHERE title='$2'"
    esac

    SQL_STATEMENT="DELETE FROM $TABLE $QUALIFIER;"
    sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT" && killall Dock
    #echo "sqlite3 $LAUNCHPAD_DB \"$SQL_STATEMENT\" && killall Dock"
}

launchpad_ls() {
    case $# in
        1) TABLE=$1
            FIELDS=*
            QUALIFIER=""
            ;;
        2) TABLE=$1
            FIELDS=*
            QUALIFIER="WHERE title LIKE '$2%'"
            ;;
        *) return
            ;;
    esac

    SQL_STATEMENT="SELECT $FIELDS FROM $TABLE $QUALIFIER;"
    sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT"
    #echo "sqlite3 $LAUNCHPAD_DB \"$SQL_STATEMENT\""
}

launchpad_info() {
    case $# in
        0) TABLE="sqlite_master"
            FIELDS="type, name, rootpage"
            QUALIFIER=""
            SQL_STATEMENT="SELECT $FIELDS FROM $TABLE $QUALIFIER;"
            ;; 
        1)
            SQL_STATEMENT="PRAGMA table_info($1);"
            ;;
    esac
    sqlite3 "$LAUNCHPAD_DB" "$SQL_STATEMENT"
}

