#!/bin/bash

#======================================================================================================================
#
#               FILE                    : entrypoint.sh
#
#               DESCRIPTION             : Starting point of the container
#
#               ARGUMENTS               : build or other commands
#
#               AUTHOR                  : Stefano Gurrieri
#
#======================================================================================================================

set -e

print_raw()
{
        echo -e "$*"
}

# Show a help message
show_help()
{
        local printer="$(echo 'print_raw')"

        "${printer}" '===================================================================================================='
        "${printer}"
        "${printer}" 'Container for building yocto'
        "${printer}"
        "${printer}" "Usage: ${0##*/}"
        "${printer}" "  [-h*] [-s=SOURCE PATH]  "
        "${printer}" "  [-i=UID:GID] [-d=DOWNLOAD PATH] [-w=WORK PATH] "
        "${printer}" "  [-c=CACHE PATH] <ACTION> "
        "${printer}"
        "${printer}" 'Application specific options:'
        "${printer}" ''"$(/usr/bin/poky-launch.sh -h)"''
        "${printer}"
        "${printer}" 'Specific options:'
        "${printer}" '-i --id           [UID:GID]       User id and group id for the permissions of the output files.'
	"${printer}" '-d --download     [DOWNLOAD PATH] Path to the directory with the downloads in container(can be empty).'
	"${printer}" '-w --work         [WORK PATH]     Path to the yocto workdir in container (can be empty).'
        "${printer}" '-s --source       [SOURCE PATH]   Path to the project, yocto layers in container (not empty!).'
        "${printer}" '-c --cache        [CACHE PATH]    Path the the cache directory in container (can be empty).'
        "${printer}"
        "${printer}" 'Optional*'
        "${printer}" '-h --help         Show this help.'
        "${printer}"
        "${printer}" '===================================================================================================='
}

check_args()
{
        if [ -z ${ID+x} ]; then
                echo "No id given"
                exit 1
        fi
        if [ -z ${WORK_DIR+x} ]; then
                echo "No work directory given"
                exit 1
        fi
        if [ -z ${DOWNLOAD_DIR+x} ]; then
                echo "No download directory given"
                exit 1
        fi
        if [ -z ${SOURCE_DIR+x} ]; then
                echo "No source directory given"
                exit 1
        fi
        if [ -z ${CACHE_DIR+x} ]; then
                echo "No cache directory given"
                exit 1
        fi
        if [ -z ${ACTION+x} ]; then
                echo "No action given"
                exit 1
        fi
        if [ ! -d ${WORK_DIR} ]; then
                echo "Directory does not exists [${WORK_DIR}]"
                exit 1
        fi
        if [ ! -d "${WORK_DIR}/.." ]; then
                echo "[${WORK_DIR}] does not have parent directory in the container."
                exit 1
        fi
        if [ ! -d ${DOWNLOAD_DIR} ]; then
                echo "Directory does not exists [${DOWNLOAD_DIR}]"
                exit 1
        fi
        if [ ! -d ${CACHE_DIR} ]; then
                echo "Directory does not exists [${CACHE_DIR}]"
                exit 1
        fi
        if [ ! -d ${SOURCE_DIR} ]; then
                echo "Directory does not exists [${SOURCE_DIR}]"
                exit 1
        fi
        if [ ! "${SOURCE_DIR##*/}" = "sources" ]; then
                echo "The source directory [${SOURCE_DIR}] in the container must be called [sources]!"
                echo "Change the -s option and the mount point."
                exit 1
        fi

        for dir in $WORK_DIR/../*
        do
                if [ $(ls -ld $dir | awk '{print $3}') == "root" ]; then
                        echo "Wrong permissions on [${dir##*/}]"
                        echo "Make sure the folder exists on the host"
                        exit 1
                fi
        done

        echo "Running in container: $ACTION"
}


main()
{
        for i in "$@"
        do
                case $i in
                        -h | --help)
                                show_help
                                exit 0
                                ;;
                        -i=* | --id=*)
                                ID="${i#*=}"
                                shift
                                ;;
                        -d=* | --download=*)
                                DOWNLOAD_DIR="${i#*=}"
                                shift
                                ;;
                        -w=* | --work=*)
                                WORK_DIR="${i#*=}"
                                shift
                                ;;
                        -s=* | --source=*)
                                SOURCE_DIR="${i#*=}"
                                shift
                                ;;
                        -c=* | --cache=*)
                                CACHE_DIR="${i#*=}"
                                shift
                                ;;
                        *)
                                ACTION="$ACTION $i"
                                shift
                                ;;
                esac
        done
}

# Start the main function
main "$@"

# Check input args
check_args

# Init yocto env
/usr/bin/usersetup.py \
        --username=pokyuser \
        --workdir "${WORK_DIR}/.." \
        --uid="${ID%:*}" \
        --gid="${ID#*:}" \
        '''/usr/bin/poky-launch.sh '"$WORK_DIR" "$DOWNLOAD_DIR" "$SOURCE_DIR" "$CACHE_DIR" "${ACTION}"''

