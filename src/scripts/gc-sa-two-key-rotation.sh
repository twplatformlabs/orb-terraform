#!/usr/bin/env bash
set -eo pipefail

# NOTE: NOTE YET RELEASED

SERVICE_ACCOUNT="$1"  # Full email, e.g., my-sa@my-project.iam.gserviceaccount.com
PROJECT_ID="$2"

if [[ -z "$SERVICE_ACCOUNT" || -z "$PROJECT_ID" ]]; then
  echo "Usage: $0 SERVICE_ACCOUNT_EMAIL PROJECT_ID"
  exit 1
fi

# Retrieve service account key metadata
KEY_INFO=$(gcloud iam service-accounts keys list \
  --iam-account="$SERVICE_ACCOUNT" \
  --project="$PROJECT_ID" \
  --format="json" | jq 'map(select(.keyType == "USER_MANAGED"))')

# Confirm expected number of keys
KEY_COUNT=$(echo "$KEY_INFO" | jq length)

if [[ "$KEY_COUNT" != "2" ]]; then
  echo "Usage: Found $KEY_COUNT keys. Provided service account is expected to have two keys in a two-key rotation pattern."
  exit 1
fi

# identify and delete oldest key
OLDEST_KEY_ID=$(echo "$KEY_INFO" | jq -r '. | sort_by(.validAfterTime) | .[0].name' | awk -F/ '{print $NF}')

echo "Delete oldest key - ID: $OLDEST_KEY_ID"
gcloud iam service-accounts keys delete "$OLDEST_KEY_ID" \
  --iam-account="$SERVICE_ACCOUNT" \
  --project="$PROJECT_ID" \
  --quiet

# generate new key and sotre result in local file
echo "Generate new key"
gcloud iam service-accounts keys create credentials.json \
  --iam-account="$SERVICE_ACCOUNT" \
  --project="$PROJECT_ID"

