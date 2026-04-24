# Starknet Dune Dashboard

Sample Dune dashboard source for tracking Starknet network activity.

## What This Includes

- Daily Starknet transaction count
- Daily active Starknet senders
- Success rate by day
- Daily fee volume
- A lightweight dashboard blueprint for Dune Agents or manual dashboard setup

## Files

- `dune/queries/01_daily_transactions.sql`
- `dune/queries/02_daily_active_senders.sql`
- `dune/queries/03_daily_success_rate.sql`
- `dune/queries/04_daily_fees.sql`
- `docs/dashboard-blueprint.md`
- `scripts/create_dune_queries.sh`

## Publish To Dune

Set a Dune API key, then run:

```bash
export DUNE_API_KEY="your_dune_api_key"
./scripts/create_dune_queries.sh
```

The script creates saved Dune queries and prints their IDs. Use those IDs to assemble the dashboard cards described in `docs/dashboard-blueprint.md`, or paste this repo into [Dune Agents](https://dune.com/agents) and ask it to create the dashboard from the SQL files.

## Notes

The SQL is deliberately conservative and should work well as a starting point. You can extend it with contract-level metrics, token transfers, app-specific events, or Ekubo/JediSwap/AVNU activity once you decide which part of Starknet you want to monitor.
