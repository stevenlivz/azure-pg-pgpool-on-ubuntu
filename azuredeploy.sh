#!/usr/bin/env bash

#RESCOURCE_GROUP="project-rg"
RESCOURCE_GROUP="dev-rg-rg"

# validate the deployment script
azure group template validate -vvv -f azuredeploy.json -e azuredeploy.parameters.json $RESCOURCE_GROUP project-data-deploy

# deploy to above resource group
azure group deployment create -vvv -f azuredeploy.json -e azuredeploy.parameters.json $RESCOURCE_GROUP project-data-deploy