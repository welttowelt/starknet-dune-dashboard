# Private Starknet Overview Dashboard

Build this as a private Dune dashboard for personal monitoring, modeled after the structure of `starkware/starknet-overview`.

## Dashboard Settings

- Title: `Private Starknet Overview`
- Visibility: Private
- Owner: personal account or private team
- Refresh: daily, or manual if you want to save credits

## Private Queries

- 30D KPIs: https://dune.com/queries/7367036
- Daily network activity: https://dune.com/queries/7367037
- Daily fees: https://dune.com/queries/7367038
- Transaction types: https://dune.com/queries/7367039
- Execution status: https://dune.com/queries/7367040
- Data availability mode: https://dune.com/queries/7367041
- Top contracts: https://dune.com/queries/7367042

## Suggested Layout

1. Header text widget
   - `Private Starknet Overview`
   - `Network usage, fees, execution health, DA mode, and contract activity.`

2. KPI row
   - Source: `30D KPIs`
   - Visualization: counter/table cards
   - Metrics:
     - `transactions_30d`
     - `avg_daily_transactions`
     - `avg_daily_active_senders`
     - `success_rate_pct`
     - `fees_token_units_30d`

3. Activity row
   - Source: `Daily network activity`
   - Visualization: dual-axis line or two line charts
   - X axis: `day`
   - Y axes: `transactions`, `active_senders`

4. Fees row
   - Source: `Daily fees`
   - Visualization: stacked area chart
   - X axis: `day`
   - Y axis: `fee_volume_token_units`
   - Series: `actual_fee_unit`

5. Composition row
   - Source: `Transaction types`
   - Visualization: pie chart or horizontal bar chart
   - Source: `Execution status`
   - Visualization: pie chart or horizontal bar chart

6. DA row
   - Source: `Data availability mode`
   - Visualization: stacked bar chart
   - X axis: `day`
   - Y axis: `transactions`
   - Series: `block_l1_da_mode`

7. Contracts row
   - Source: `Top contracts`
   - Visualization: table
   - Columns: `contract_address`, `transactions`, `unique_senders`

## Dune Agent Prompt

Create a private dashboard named "Private Starknet Overview" using these private Dune queries:

- 7367036 for headline 30 day KPIs
- 7367037 for daily transactions and active senders
- 7367038 for daily fees by fee unit
- 7367039 for transaction type mix
- 7367040 for execution status split
- 7367041 for data availability mode over time
- 7367042 for top contracts

Make the dashboard structure similar to `https://dune.com/starkware/starknet-overview`: KPI cards first, network activity and fees below, then composition charts and a top contracts table. Keep the dashboard private.
