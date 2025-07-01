#!/usr/bin/env bash
set -eo pipefail

cat <<EOF > $OUTFILE
terraform {
  cloud {
    organization = "${TFC_ORGANIZATION}"
    hostname = "app.terraform.io"

    workspaces {
      name = "${TFC_WORKSPACE_PREFIX}${TFC_WORKSPACE}"
    }
  }
}

EOF
