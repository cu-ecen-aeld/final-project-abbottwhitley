#!/bin/bash
#Script to build buildroot configuration
#Author: Siddhant Jajoo

source shared.sh

EXTERNAL_REL_BUILDROOT=../base_external
git submodule init
git submodule sync
git submodule update

set -e 
cd `dirname $0`


echo ############################################################
echo EXTERNAL_REL_BUILDROOT: ${EXTERNAL_REL_BUILDROOT}
echo AESD_MODIFIED_DEFCONFIG: ${AESD_MODIFIED_DEFCONFIG}
echo AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT: ${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
echo ############################################################

rm -Rf buildroot/output/build/aesd-final-1

if [ ! -e buildroot/.config ]
then
	echo -e "\n MISSING BUILDROOT CONFIGURATION FILE \n"

	if [ -e ${AESD_MODIFIED_DEFCONFIG} ]
	then
		echo "USING ${AESD_MODIFIED_DEFCONFIG}"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
	else
		echo "Run ./save_config.sh to save this as the default configuration in ${AESD_MODIFIED_DEFCONFIG}"
		echo "Then add packages as needed to complete the installation, re-running ./save_config.sh as needed"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_DEFAULT_DEFCONFIG}
	fi
else
	echo "\n USING EXISTING BUILDROOT CONFIG \n"
	echo -e "\n TO FORCE UPDATE, DELETE .config OR MAKE CHANGES USING make menuconfig AND BUILD AGAIN\n"
#	make -C buildroot AESD_FINAL_OVERRIDE_SRCDIR=~/CU_Boulder/assignment-3-abbottwhitley aesd-final-dirclean
	make -C buildroot BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} #AESD_FINAL_OVERRIDE_SRCDIR=~/CU_Boulder/assignment-3-abbottwhitley aesd-final-rebuild

fi
