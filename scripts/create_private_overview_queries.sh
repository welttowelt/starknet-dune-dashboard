#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${DUNE_API_KEY:-}" ]]; then
  echo "DUNE_API_KEY is not set." >&2
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
    --header "X-DUNE-API-KEY: $DUNE_API_KEY" \
    --header "Content-Type: application/json" \
    --data "{
      \"name\": \"$name\",
      \"description\": \"$description\",
      \"query_sql\": $sql,
      \"is_private\": true,
      \"tags\": [\"starknet\", \"private-overview\", \"welttowelt\"]
    }" | jq -r '.query_id'
}

kpi_30d="$(create_query "Private Starknet Overview - 30D KPIs" "Headline KPIs for a private Starknet overview dashboard." "$ROOT_DIR/dune/private-overview/01_kpi_last_30_days.sql")"
daily_activity="$(create_query "Private Starknet Overview - Daily Activity" "Daily transactions and active senders." "$ROOT_DIR/dune/private-overview/02_daily_network_activity.sql")"
daily_fees="$(create_query "Private Starknet Overview - Daily Fees" "Daily fee volume grouped by fee unit." "$ROOT_DIR/dune/private-overview/03_daily_fees_by_unit.sql")"
tx_types="$(create_query "Private Starknet Overview - Transaction Types" "Transaction type mix over the trailing 30 days." "$ROOT_DIR/dune/private-overview/04_transaction_types_30_days.sql")"
execution_status="$(create_query "Private Starknet Overview - Execution Status" "Execution status split over the trailing 30 days." "$ROOT_DIR/dune/private-overview/05_execution_status_30_days.sql")"
da_mode="$(create_query "Private Starknet Overview - DA Mode" "Blob versus calldata usage by day." "$ROOT_DIR/dune/private-overview/06_data_availability_mode.sql")"
top_contracts="$(create_query "Private Starknet Overview - Top Contracts" "Most touched contracts over the trailing 30 days." "$ROOT_DIR/dune/private-overview/07_top_contracts_30_days.sql")"

jq -n \
  --argjson kpi_30d "$kpi_30d" \
  --argjson daily_activity "$daily_activity" \
  --argjson daily_fees "$daily_fees" \
  --argjson tx_types "$tx_types" \
  --argjson execution_status "$execution_status" \
  --argjson da_mode "$da_mode" \
  --argjson top_contracts "$top_contracts" \
  '{
    kpi_30d: $kpi_30d,
    daily_activity: $daily_activity,
    daily_fees: $daily_fees,
    tx_types: $tx_types,
    execution_status: $execution_status,
    da_mode: $da_mode,
    top_contracts: $top_contracts
  }' | tee "$ROOT_DIR/dune/private-overview/query-ids.json"
