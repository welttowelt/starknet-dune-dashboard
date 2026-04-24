#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DUNE_API_KEY:-}" ]]; then
  echo "DUNE_API_KEY is not set." >&2
  echo "Create a Dune API key, export it, then rerun this script." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_BASE="${DUNE_API_BASE:-https://api.dune.com/api/v1}"

create_query() {
  local name="$1"
  local description="$2"
  local file="$3"
  local sql

  sql="$(jq -Rs . < "$file")"

  curl --fail --silent --show-error \
    --request POST \
    --url "$API_BASE/query" \
    --header "X-Dune-API-Key: $DUNE_API_KEY" \
    --header "Content-Type: application/json" \
    --data "{
      \"name\": \"$name\",
      \"description\": \"$description\",
      \"query_sql\": $sql,
      \"is_private\": false,
      \"tags\": [\"starknet\", \"sample-dashboard\", \"welttowelt\"]
    }" | jq .
}

create_query "Starknet - Daily Transactions" "Daily Starknet transaction count for the trailing 90 days." "$ROOT_DIR/dune/queries/01_daily_transactions.sql"
create_query "Starknet - Daily Active Senders" "Daily active Starknet senders for the trailing 90 days." "$ROOT_DIR/dune/queries/02_daily_active_senders.sql"
create_query "Starknet - Daily Success Rate" "Daily Starknet execution success rate for the trailing 90 days." "$ROOT_DIR/dune/queries/03_daily_success_rate.sql"
create_query "Starknet - Daily Fee Volume" "Daily Starknet fee volume grouped by fee unit for the trailing 90 days." "$ROOT_DIR/dune/queries/04_daily_fees.sql"
