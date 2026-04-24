# Starknet Network Activity Dashboard

## Dashboard Title

Starknet Network Activity

## Description

A compact view of Starknet usage over the last 90 days, focused on transactions, active senders, execution success, and fee volume.

## Cards

1. Daily Transactions
   - Query: `dune/queries/01_daily_transactions.sql`
   - Dune query: https://dune.com/queries/7367013
   - Visualization: bar chart
   - X axis: `day`
   - Y axis: `transactions`

2. Daily Active Senders
   - Query: `dune/queries/02_daily_active_senders.sql`
   - Dune query: https://dune.com/queries/7367014
   - Visualization: line chart
   - X axis: `day`
   - Y axis: `active_senders`

3. Success Rate
   - Query: `dune/queries/03_daily_success_rate.sql`
   - Dune query: https://dune.com/queries/7367015
   - Visualization: line chart
   - X axis: `day`
   - Y axis: `success_rate_pct`

4. Daily Fee Volume
   - Query: `dune/queries/04_daily_fees.sql`
   - Dune query: https://dune.com/queries/7367016
   - Visualization: area chart
   - X axis: `day`
   - Y axis: `fee_volume_token_units`
   - Series: `actual_fee_unit`

## Suggested Layout

- Row 1: Daily Transactions, Daily Active Senders
- Row 2: Success Rate, Daily Fee Volume

## Dune Agent Prompt

Create a Dune dashboard called "Starknet Network Activity" using the SQL files in this repository. Add four visualizations: daily transactions as a bar chart, daily active senders as a line chart, transaction success rate as a line chart, and daily fee volume as an area chart. Use a 90 day trailing window and title each card using the section names from `docs/dashboard-blueprint.md`.
