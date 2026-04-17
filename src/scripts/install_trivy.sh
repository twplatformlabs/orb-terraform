#!/usr/bin/env bash
set -eo pipefail

# verify install version
cosign verify aquasec/trivy:"${TRIVY_VERSION}" \
--certificate-identity-regexp 'https://github\.com/aquasecurity/trivy/\.github/workflows/.+' \
--certificate-oidc-issuer "https://token.actions.githubusercontent.com"

# install trivy version
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v"${TRIVY_VERSION}"
trivy --version
