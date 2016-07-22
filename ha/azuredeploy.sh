#!/usr/bin/env bash

#RESCOURCE_GROUP="project-rg"
RESCOURCE_GROUP="dev-rg-rg"

# validate the deployment script
azure group template validate -vvv -f azuredeploy.json -e azuredeploy0.parameters.json $RESCOURCE_GROUP project-data-ha-0-deploy

# deploy to above resource group
azure group deployment create -vvv -f azuredeploy.json -e azuredeploy0.parameters.json $RESCOURCE_GROUP project-data-ha-0-deploy

# validate the deployment script
azure group template validate -vvv -f azuredeploy.json -e azuredeploy1.parameters.json $RESCOURCE_GROUP project-data-ha-1-deploy

# deploy to above resource group
azure group deployment create -vvv -f azuredeploy.json -e azuredeploy1.parameters.json $RESCOURCE_GROUP project-data-ha-1-deploy