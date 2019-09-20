#!/bin/bash 
#======================================================================================================================
#
#		FILE			: poky_launch.sh
#
#		DESCRIPTION		: Launch the poky environment
#
#		ARGUMENTS		: [WORK_DIR] [DOWNLOAD_DIR] [SOURCE_DIR] [CACHE_DIR] [ACTION]
#
#		AUTHORS			: Stefano Gurrieri
#
#======================================================================================================================

set -e

readonly WORK_DIR="${1}"
readonly DOWNLOAD_DIR="${2}"
readonly SOURCE_DIR="${3}"
readonly CACHE_DIR="${4}"
readonly ACTION="${@:5}"

# Show help
if [ "${1}" == "-h" ]; then
	echo "	<ACTION> (one of the following)"
	echo "	[build image <MACHINE_CONF>]	Build the roj-demokit image for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb, imx6soloenuc_512mb, imx6soloenuc_1gb)"
	echo "	[build kernel <MACHINE_CONF>]	Build the kernel for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb, imx6soloenuc_512mb, imx6soloenuc_1gb)"
	echo "	[build uboot <MACHINE_CONF>]	Build the u-boot for the MACHINE_CONF (imx6qenuc_1gb, imx6qenuc_2gb, imx6soloenuc_512mb, imx6soloenuc_1gb)"
	echo "	[run <COMMAND>]			Init the work dir and run the COMMAND"
	echo "	[init]				Init the work dir"
	echo "	[<COMMAND>]			Run a COMMAND"
	exit 0
fi

# Check the amount of arguments
if [ "${#}" -lt 5 ]; then
	echo "Invalid amount of arugments"
	exit 1
fi

# Go the the root folder of all the files
cd "${WORK_DIR}/.."

# Initialise the build and conf directory for bitbake
init_cmd()
{
	if [ ! -d "${SOURCE_DIR##*/}" ]; then
		echo "Make sure the sources directory exists [${SOURCE_DIR##*/}]"
		exit 1
	fi

	rm -rf ${SOURCE_DIR##*/}/base
	cp -r ${SOURCE_DIR##*/}/base-roj-platform ${SOURCE_DIR##*/}/base

	ln -s ${SOURCE_DIR##*/}/fsl-community-bsp-base/README README
	ln -s ${SOURCE_DIR##*/}/fsl-community-bsp-base/setup-environment setup-environment
	ln -s ${SOURCE_DIR##*/}/meta-fsl-bsp-release/imx/README README-IMXBSP
	ln -s ${SOURCE_DIR##*/}/meta-fsl-bsp-release/imx/tools/fsl-setup-release.sh fsl-setup-release.sh

	source ./fsl-setup-release.sh -b ${WORK_DIR##*/} > /dev/null

	# Fix download dir in local.conf
	sed -i 's/\(DL_DIR ?= \)\(\".*\"\)/\1\"\$\{BSPDIR\}\/'"${DOWNLOAD_DIR##*/}"'\"/g' conf/local.conf


	# Fix sstate cache dir in local.conf
	sed -i 's/\(SSTATE_DIR ?= \)\(\".*\"\)/\1\"\$\{BSPDIR\}\/'"${CACHE_DIR##*/}"'\"/g' conf/local.conf


	# Fix source dir in bblayers.conf
	sed -i 's/\(SOURCE_DIR ?= \)\(\".*\"\)/\1\"'"${SOURCE_DIR##*/}"'\"/g' conf/local.conf
}

# cleanup base directory
cleanup()
{
	cd "${WORK_DIR}/.."
	rm -rf ${SOURCE_DIR##*/}/base
}

# Initialise the bitbake command and run the command [COMMAND]
run_cmd()
{
	if [ ! -d "${WORK_DIR##*/}/conf" ]; then
		echo "Initialising the build by running [init]"
		init_cmd
	else
		ln -s ${SOURCE_DIR##*/}/fsl-community-bsp-base/setup-environment setup-environment
		rm -rf ${SOURCE_DIR##*/}/base
		cp -r ${SOURCE_DIR##*/}/base-roj-platform ${SOURCE_DIR##*/}/base
		source setup-environment "${WORK_DIR##*/}" > /dev/null
	fi

	command bash -c "${@}"

	cleanup
}

# Parse action
case "${ACTION}" in
	"build image "*)
		(set -e ; \
			run_cmd "bitbake -q -w '' --read=${WORK_DIR}/conf/${ACTION##* }.conf core-image-minimal" && exit 0 \
		)
		;;
	"build kernel "*)
		(set -e ; \
			run_cmd "bitbake -q -w '' --read=${WORK_DIR}/conf/${ACTION##* }.conf linux-imx" && exit 0 \
		)
		;;
	"build uboot "*)
		(set -e ; \
			run_cmd "bitbake -q -w '' --read=${WORK_DIR}/conf/${ACTION##* }.conf u-boot-imx" && exit 0 \
		)
		;;
	"clean")
		(set -e ; \
			run_cmd "bitbake -c clean world" && exit 0 \
		)
		;;
	"run "*)
		(set -x ; \
			run_cmd "${ACTION#* }" && exit 0 \
		)
		;;
	"init")
		(set -e ;\
			init_cmd && cleanup &&exit 0 \
		)
		;;
	*)
		# run whatever the user wanted to
		(set -x ; exec ${@:5} && exit 0)
esac
