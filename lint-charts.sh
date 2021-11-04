#!/usr/bin/env bash

#
# Script to Lint all charts
#

echo "Linting all Charts..."

set -e

LOCAL_HELM_MOJALOOP_REPO_URI=${HELM_MOJALOOP_REPO_URI:-'https://docs.mojaloop.io/helm/repo'}

trap 'echo "Command failed...exiting. Please fix me!"' ERR


if [ "$1" ]; then
    declare -a charts=("$1")
else
    declare -a charts=(
        # Example Backend Dependency Charts
        mojaloop/example-backend
        # Common Charts
        mojaloop/common
        # Mojaloop BoF Charts
        mojaloop/security-role-perm-crd
        mojaloop/role-assignment-service
        mojaloop/reporting-hub-bop-shell
        mojaloop/reporting-hub-bop-api-svc
        mojaloop/reporting-events-processor-svc
        mojaloop/security-role-perm-operator-svc
        mojaloop/reporting-hub-bop-role-ui
        mojaloop/reporting-hub-bop-trx-ui
        mojaloop/security-hub-bop-kratos-ui
        mojaloop/bof
        ## placeholder
        # Mojaloop Core Charts
        mojaloop/admin-api-svc
        mojaloop/fspiop-transfer-api-svc
        # Main Mojaloop Helm Chart 
        mojaloop/mojaloop
    )
fi

echo "\n"

for chart in "${charts[@]}"
do
    echo "---=== Linting $chart ===---"
    helm lint $chart
done

echo "\
Chart linting completed.\n \
Ensure you check the output for any errors. \n \
Ignore any http errors when connecting to \"local\" chart repository.\n \
\n \
Happy Helming!
"
