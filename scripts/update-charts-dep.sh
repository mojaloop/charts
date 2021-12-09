#!/usr/bin/env bash

#
# Script to update all Helm Chart Dependencies
#

set -eu

trap 'echo "Dep update failed...exiting. Please fix me!"' ERR

echo "Removing old charts..."
find ./ -name "charts"| xargs rm -Rf
find ./ -name "tmpcharts"| xargs rm -Rf

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
        mojaloop/reporting-legacy-api
        mojaloop/security-hub-bop-kratos-ui
        mojaloop/bof
        ## placeholder
        # Mojaloop Core Charts
        mojaloop/admin-api-svc
        mojaloop/fspiop-transfer-api-svc
        # Main Mojaloop Helm Chart 
        mojaloop/mojaloop
    )

echo "Updating all Charts..."
for chart in "${charts[@]}"
do
    echo "---=== Updating $chart ===---"
    helm dep up "$chart" --skip-refresh
done

set +x

echo "\
Chart updates completed.\n \
Ensure you check the output for any errors. \n \
Ignore any http errors when connecting to \"local\" chart repository.\n \
\n \
Happy Helming!
"
