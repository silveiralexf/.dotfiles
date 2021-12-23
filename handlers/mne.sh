#!/bin/bash

METHOD=$1
UUID=$2
CREDENTIALS=mneaas:mneaas4all

#curl -X DELETE -k -s -u "$CREDENTIALS" https://portal-dev-01-mneaas.nonprod.extnet.ibm.com/services/rest/v1/resourcemgmt/computersystems/$UUID
curl -k -s -u "$CREDENTIALS" -X $METHOD https://resources.api.shared1.mneaas.ams.sp.ibm.com/services/rest/v1/resourcemgmt/computersystems/$UUID
#curl -k -s -u "$CREDENTIALS" -X $METHOD https://resources.api.preprod.mneaas.ams.sp.ibm.com/services/rest/v1/resourcemgmt/computersystems/$UUID
#curl -v -k -s -u "$CREDENTIALS" -X $METHOD https://resources.api.prod-01.mneaas.ams.sp.ibm.com/services/rest/v1/resourcemgmt/computersystems/$UUID
#curl -k -s -u "$CREDENTIALS" -X $METHOD https://resources.api.dev-01.mneaas.sp.ibm.com/services/rest/v1/resourcemgmt/resources/$UUID
#curl -k -s -u "$CREDENTIALS" -X $METHOD https://resources.api.test-01.mneaas.sp.ibm.com/services/rest/v1/resourcemgmt/resources/$UUID
