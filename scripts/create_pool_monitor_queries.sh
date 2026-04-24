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
      \"tags\": [\"starknet\", \"pool-monitor\", \"welttowelt\"]
    }" | jq -r '.query_id'
}

balances="$(create_query "Private Starknet Pool - Current Balances and TVL" "Estimated current token balances and USD TVL for the watched Starknet pool." "$ROOT_DIR/dune/pool-monitor/01_pool_current_balances_and_tvl.sql")"

tmp_summary="$(mktemp)"
sed "s/query_7367043/query_${balances}/g" "$ROOT_DIR/dune/pool-monitor/02_pool_tvl_summary.sql" > "$tmp_summary"
summary="$(create_query "Private Starknet Pool - TVL Summary" "Headline estimated TVL summary for the watched Starknet pool." "$tmp_summary")"
rm -f "$tmp_summary"

flows="$(create_query "Private Starknet Pool - Daily Token Flows" "Daily token inflows and outflows for the watched Starknet pool." "$ROOT_DIR/dune/pool-monitor/03_pool_daily_token_flows.sql")"
recent="$(create_query "Private Starknet Pool - Recent Transfers" "Recent token transfers touching the watched Starknet pool." "$ROOT_DIR/dune/pool-monitor/04_pool_recent_transfers.sql")"
txs="$(create_query "Private Starknet Pool - Contract Transactions" "Transactions directly targeting or emitted by the watched pool contract." "$ROOT_DIR/dune/pool-monitor/05_pool_contract_transactions.sql")"

jq -n \
  --argjson balances "$balances" \
  --argjson summary "$summary" \
  --argjson flows "$flows" \
  --argjson recent "$recent" \
  --argjson txs "$txs" \
  '{
    pool_address: "0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a",
    current_balances_and_tvl: $balances,
    tvl_summary: $summary,
    daily_token_flows: $flows,
    recent_transfers: $recent,
    contract_transactions: $txs
  }' | tee "$ROOT_DIR/dune/pool-monitor/query-ids.json"
