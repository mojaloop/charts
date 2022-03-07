# Contributing Guidlines

- [Contributing Guidlines](#contributing-guidlines)
  - [How to Contribute](#how-to-contribute)
    - [Technical Requirements](#technical-requirements)
    - [Documentation Requirements](#documentation-requirements)
  - [Chart Standards](#chart-standards)
    - [Chart Naming Conventions](#chart-naming-conventions)
  - [Reference Architecture Alignment](#reference-architecture-alignment)

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

Any type of contribution is welcome; from new features, bug fixes, documentation improvements or even adding charts to the repository (if it's viable once evaluated the feasibility).

## How to Contribute

Please read the official [Mojaloop Contributors Guide](https://docs.mojaloop.io/legacy/contributors-guide/) for more detailed information.

1. Fork this repository [ref](https://docs.mojaloop.io/legacy/contributors-guide/standards/creating-new-features.html#fork)
2. Create a new branch [ref](https://docs.mojaloop.io/legacy/contributors-guide/standards/creating-new-features.html#creating-a-branch)
3. Submit a pull request [ref](https://docs.mojaloop.io/legacy/contributors-guide/standards/creating-new-features.html#open-a-pull-request-pr), ensure you follow the [PR title conventions](https://docs.mojaloop.io/legacy/contributors-guide/standards/creating-new-features.html#pull-request-titles)

NOTE: To make the Pull Requests' (PRs) testing and merging process easier, please submit changes to multiple charts in separate PRs unless the changes are related.

### Technical Requirements

When submitting a PR make sure that it:

1. Must pass CI jobs for linting and test the changes on top of different k8s platforms.
2. Must follow Helm best practices.
3. Any change to a chart requires a version bump following semver principles. This is the version that is going to be merged in the GitHub repository, then our CI/CD system is going to publish in the Helm registry a new patch version including your changes and the latest images and dependencies.

### Documentation Requirements

1. A chart's README.md must include configuration options. The tables of parameters are generated based on the metadata information from the values.yaml file, by using this [tool](https://github.com/bitnami-labs/readme-generator-for-helm).
2. A chart's NOTES.txt must include relevant post-installation information, and copyright information (if/when applicable).

## Chart Standards

### Chart Naming Conventions

Chart names should follow the Mojaloop Repository naming conventions as stated in the following [document](tobeprovided).

The following table shows the v14 to v13 component name mapping:

v14 Chart                             | v13 Chart                                    | Component               | Notes
--------------------------------------|----------------------------------------------|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------
fspiop-transfer-bc                    | ml-api-adapter                               | wrapper                 | Wrapper for fspiop-transfer-* charts
fspiop-transfer-api-svc               | ml-api-adapter-service                       | ml-api-adapter          | Handles FSPIOP Transfer API Requests
fspiop-transfer-notification-svc      | ml-api-adapter-handler-notification          | ml-api-adapter          | Handles FSPIOP Transfer API Notifications (outbound requests/callbacks)
cl-transfer-bc                        | centralledger                                | wrapper                 | Handles Central-Ledger Admin Operations (i.e. creating participants, creating accounts, setting NDC, setting end-points, etc)
cl-admin-api-svc                      | centralledger-service                        | central-ledger          | Handles Central-Ledger Admin Operations (i.e. creating participants, creating accounts, setting NDC, setting end-points, etc)
cl-transfer-admin-svc                 | centralledger-handler-admin-transfer         | central-ledger          | Handles funds-in/funds-out
cl-transfer-timeout-svc               | centralledger-handler-timeout                | central-ledger          | Cronjob handler for timing out Transfer requests
cl-transfer-fulfil-svc                | centralledger-handler-transfer-fulfil        | central-ledger          | Handles processing Transfer Fulfilment callbacks
cl-transfer-get-svc                   | centralledger-handler-transfer-get           | central-ledger          | Handles processing Transfer Get requests
cl-transfer-position-svc              | centralledger-handler-transfer-position      | central-ledger          | Handles processing transfers for position management
cl-transfer-prepare-svc               | centralledger-handler-transfer-prepare       | central-ledger          | Handles processing Transfer Prepare requests
fspiop-account-lookup-bc              | account-lookup-service                       | wrapper                 | Wrapper for fspiop-account-* charts
fspiop-account-lookup-api-svc         | account-lookup-service                       | account-lookup-service  | Handles FSPIOP Participant & Party API requests, processing and callbacks
fspiop-account-lookup-admin-api-svc   | account-lookup-service-admin                 | account-lookup-service  | Handles Account-lookup Admin Operations (i.e. registering oracles, etc)
fspiop-quoting-bc                     | quoting-service                              | wrapper                 | Wrapper for fspiop-quoting-* charts
fspiop-quoting-api-svc                | quoting-service                              | quoting-service         | Handles FSPIOP Quoting API requests, processing and callbacks
fspiop-transaction-req-api-svc        | transaction-requests-service                 | transaction-requests    | Handles FSPIOP Transaction API requests, processing and callbacks
settlement-api-svc                    | centralsettlement-service                    | central-settlement      | Handles Settlement API requests, and processing
settlement-differed-svc               | centralsettlement-handler-deferredsettlement | central-settlement      | Handles Settlement processing for differed settlement models
settlement-gross-svc                  | centralsettlement-handler-grosssettlement    | central-settlement      | Handles Settlement processing for differed gross models
settlement-rules-svc                  | centralsettlement-handler-rules              | central-settlement      | Handles Settlement processing of custom configured rules
fspiop-bulk-transfer-api-svc          | bulk-api-adapter-service                     | bulk-api-adapter        | Handles FSPIOP Bulk Transfer API Requests
fspiop-bulk-transfer-bc               | mojaloop-bulk                                | wrapper                 | Wrapper for fspiop-bulk-* charts
fspiop-bulk-transfer-notification-svc | bulk-api-adapter-handler-notification        | bulk-api-adapter        | Handles FSPIOP Bulk Transfer API Notifications (outbound requests/callbacks)
cl-bulk-transfer-bc                   | centralledger                                | wrapper                 | Wrapper for fspiop-bulk-transfer-* charts
cl-bulk-transfer-prepare-svc          | cl-handler-bulk-transfer-prepare             | central-ledger          | Handles processing Bulk Transfer Prepare requests
cl-bulk-transfer-processing-svc       | cl-handler-bulk-transfer-processing          | central-ledger          | Handles Bulk Transfer correlation processing
cl-bulk-transfer-fulfil-svc           | cl-handler-bulk-transfer-fulfil              | central-ledger          | Handles processing Bulk Transfer Fulfilment callbacks
cl-bulk-transfer-get-svc              | cl-handler-bulk-transfer-get                 | central-ledger          | Handles processing Bulk Transfer Get requests
email-notifier-svc                    | emailnotifier                                | email-notifier          | Handles sending out email-notifications as a result of monitoring centraleventprocessor events
central-event-processor-svc           | centraleventprocessor                        | central-event-processor | Handles event-processing for triggering NDC Cap Near Exceed out email-notifications as a result of monitoring message-streams
reporting-bc                          | finance-portal                               | wrapper                 | Wrapper for finance-*
finance-ui                            | finance-portal                               | finance-portal          | UI for finance operations
finance-settlement-mgmt-svc           | finance-portal-settlement-management         | settlement-management   | Handles functionality to close a settlement window and generate a payment file for reconciliation with the settlement bank
simulator-bc                          | n/a                                          | wrapper                 | Wrapper for sim* charts
simulator-api-svc                     | simulator                                    | simulator               | Legacy Mojaloop static simulator for FSPIOP Operations and Oracles (which it is still used for)
sim-*-backend-api-svc                 | sim-*-backend                                | mojaloop-simulator      | Simulator for FSP Backends that integrates with the SDK-Scheme-Adapter that support configurable rules for mocking FSP core-system behaviour
sim-*-scheme-adapter-api-svc          | sim-*-scheme-adapter                         | sdk-scheme-adapter      | FSP Adapter services which simplifies integration with Mojaloop Hubs by supporting both asynchronous and synchronous API operations
thirdparty-bc                         | thirdparty                                   | wrapper                 | Wrapper for thirdparty-*, authorization-*, als-consent-* charts
thirdparty-api-svc                    | tp-api-svc                                   | thirdparty-api-svc      | Handles Third-party API requests, processing and callbacks
authorization-api-svc                 | auth-svc                                     | auth-service            | Handles Third-party Authorization API requests, processing and callbacks
als-consent-oracle-api-svc            | consent-oracle                               | als-consent-oracle      | Third-party Consent Oracle for the Account-Lookup-Service

## Reference Architecture Alignment
