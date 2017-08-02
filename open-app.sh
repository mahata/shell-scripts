#!/bin/bash -e

PROGNAME=$(basename "$0")
VERSION="0.1"

usage() {
    echo "Usage: $PROGNAME [OPTIONS] APP"
    echo "  This script starts a specified app if it's not open yet."
    echo
    echo "Options:"
    echo "  -h, --help"
    echo "      --version"
    echo
    exit 1
}

for OPT in "$@"
do
    case "$OPT" in
        '-h'|'--help' )
            usage
            exit 1
            ;;
        '--version' )
            echo $VERSION
            exit 1
            ;;
        '--'|'-' )
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo "$1" | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ -z "$param" ]; then
    echo "$PROGNAME: too few arguments" 1>&2
    echo "Try '$PROGNAME --help' for more information." 1>&2
    exit 1
fi

if [[ $(ps ax | grep "$param" | grep -v grep | grep -c -v "$PROGNAME") -eq 0 ]]; then
    open "$param"
    exit 0
fi

exit 1
