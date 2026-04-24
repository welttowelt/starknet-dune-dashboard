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
      \"tags\": [\"starknet\", \"pool-monitor\", \"welttowelt\", \"events\"]
    }" | jq -r '.query_id'
}

event_types="$(create_query "Private Starknet Pool - Event Types" "Event selector distribution emitted by the watched pool contract." "$ROOT_DIR/dune/pool-monitor/06_pool_event_types.sql")"
daily_events="$(create_query "Private Starknet Pool - Daily Events" "Daily emitted event counts by selector for the watched pool contract." "$ROOT_DIR/dune/pool-monitor/07_pool_daily_events.sql")"
recent_events="$(create_query "Private Starknet Pool - Recent Raw Events" "Recent raw events emitted by the watched pool contract." "$ROOT_DIR/dune/pool-monitor/08_pool_recent_events.sql")"
token_candidates="$(create_query "Private Starknet Pool - Token Candidates" "Token-like addresses observed in pool contract events and matched to Dune prices." "$ROOT_DIR/dune/pool-monitor/09_pool_token_candidates.sql")"

jq -n \
  --argjson event_types "$event_types" \
  --argjson daily_events "$daily_events" \
  --argjson recent_events "$recent_events" \
  --argjson token_candidates "$token_candidates" \
  '{
    event_types: $event_types,
    daily_events: $daily_events,
    recent_events: $recent_events,
    token_candidates: $token_candidates
  }' | tee "$ROOT_DIR/dune/pool-monitor/event-query-ids.json"
