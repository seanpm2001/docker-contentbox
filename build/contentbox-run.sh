#!/bin/bash
set -e

# Move into CommandBox image work dir
cd ${APP_DIR}

#######################################################################################
# ContentBox BE Edition
# This has to be here, since our original image is baked with the latest stable
#######################################################################################
if [[ $BE ]] && [[ $BE = true ]]; then
	echo ">INFO: Bleeding Edge installation specified. Overwriting install"
	box install contentbox-installer@be --production --force
fi;

#######################################################################################
# Express Edition
#######################################################################################
if [[ $EXPRESS ]] && [[ $EXPRESS == true ]]; then

	echo ">INFO: Express installation specified.  Configuring H2 Database."

	if [[ ! $H2_DIR ]]; then
		export H2_DIR=/data/contentbox/db
		# H2 Database Directory
		mkdir -p ${H2_DIR}
	fi

	echo ">INFO: H2 Database set to ${H2_DIR}"

	#check for a lock file and remove it so we can start up
	if [[ -f ${H2_DIR}/contentbox.lck ]]; then
		rm -f ${H2_DIR}/contentbox.lck
	fi

fi

#######################################################################################
# Enabling Rewrites
#######################################################################################
if [[ ! -f ${APP_DIR}/server.json ]]; then
	echo ">INFO: Enabling rewrites..."
	box server set web.rewrites.enable=true
fi

#######################################################################################
# INSTALLER
# If our installer flag has not been passed, then remove that module
#######################################################################################
if [[ ! $INSTALL ]] || [[ $INSTALL == false ]]; then
	echo ">INFO: Removing installer..."
	rm -rf ${APP_DIR}/modules/contentbox-installer
fi

#######################################################################################
# REMOVE_CBADMIN
# If true, then remove the contentbox admin
#######################################################################################
if [[ $REMOVE_CBADMIN ]] && [[ $REMOVE_CBADMIN == true ]]; then
	echo ">INFO: Removing admin module..."
	rm -rf ${APP_DIR}/modules/contentbox/modules/contentbox-admin
fi

#######################################################################################
# CONTENTBOX_MIGRATE
# If true, then run any outstanding migrations
#######################################################################################
if [[ $CONTENTBOX_MIGRATE ]] && [[ $CONTENTBOX_MIGRATE == true ]]; then
	echo ">INFO: Running any outstanding ContentBox migrations..."
	cd $APP_DIR && box migrate up migrationsDirectory=modules/contentbox/migrations
fi

#######################################################################################
# Media Directory
# Check for path environment variables and then apply convention routes to them if not specified
#######################################################################################
if [[ ! $contentbox_default_cb_media_directoryRoot ]]; then
	export contentbox_default_cb_media_directoryRoot=/app/modules_app/contentbox-custom/_content
fi
# Create media directory, just in case.
mkdir -p $contentbox_default_cb_media_directoryRoot
echo ">INFO: Contentbox media root set as ${contentbox_default_cb_media_directoryRoot}"
echo "==> ContentBox Environment Finalized"

# Run CommandBox Server Now
${BUILD_DIR}/run.sh