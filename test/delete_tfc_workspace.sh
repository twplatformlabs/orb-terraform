#!/usr/bin/env bash
set -eo pipefail

TFC_ORGANIZATION=twplatformlabs
TFC_WORKSPACE=orb-terraform-ci

# setup curl parameters
tfc_api_url="https://app.terraform.io/api/v2/organizations"
tfc_api_url_workspace_by_name="$tfc_api_url/$TFC_ORGANIZATION/workspaces/$TFC_WORKSPACE"

headers=(
  "Authorization: Bearer $TFE_TOKEN"
  "Content-Type: application/vnd.api+json"
)
echo "deleteing workspace $TFC_WORKSPACE"
deleteworkspace=$(curl --header "${headers[0]}" \
                        --header "${headers[1]}" \
                        --request DELETE \
                        "$tfc_api_url_workspace_by_name")
echo "$deleteworkspace"