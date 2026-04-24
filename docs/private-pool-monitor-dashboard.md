# Private Pool Monitor Dashboard

Watched pool:

`0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a`

Voyager:

https://voyager.online/contract/0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a

## Private Dune Queries

- Current balances and estimated TVL: https://dune.com/queries/7367047
- TVL summary: https://dune.com/queries/7367048
- Daily token flows: https://dune.com/queries/7367049
- Recent transfers: https://dune.com/queries/7367050
- Contract transactions: https://dune.com/queries/7367051
- Event types: https://dune.com/queries/7367061
- Daily events: https://dune.com/queries/7367062
- Recent raw events: https://dune.com/queries/7367063
- Token candidates: https://dune.com/queries/7367064

## Important TVL Note

This contract emits Ekubo-style pool events, but it does not appear to hold token balances directly via plain ERC-20 `Transfer` events. Query `7367047` ran successfully and returned zero balance rows.

For true current concentrated-liquidity TVL, use Ekubo's protocol indexer/API as the source of truth, then optionally upload the snapshots into Dune. Ekubo documents that its website API is backed by an open source Postgres indexer and exposes pool liquidity endpoints at `https://prod-api.ekubo.org`.

## Dashboard Layout

1. Header
   - Title: `Private Starknet Pool Monitor`
   - Subtitle: pool address and Voyager link

2. KPI row
   - Query: `7367048`
   - Cards:
     - `estimated_tvl_usd`
     - `token_count`
     - `largest_token_balance_usd`

3. Balances table
   - Query: `7367047`
   - Table columns:
     - `token_address`
     - `symbol`
     - `balance`
     - `price_usd`
     - `balance_usd`

4. Daily flows
   - Query: `7367049`
   - Visualization: stacked bar chart or area chart
   - X axis: `day`
   - Y axis: `amount_usd`
   - Series: `direction`
   - Optional split: `symbol`

5. Recent transfers
   - Query: `7367050`
   - Visualization: table
   - Columns:
     - `block_time`
     - `direction`
     - `symbol`
     - `amount`
     - `from_account`
     - `to_account`
     - `transaction_hash`

6. Contract transactions
   - Query: `7367051`
   - Visualization: line or stacked bar
   - X axis: `day`
   - Y axis: `transactions`
   - Series: `execution_status`

7. Event activity
   - Query: `7367062`
   - Visualization: stacked bar
   - X axis: `day`
   - Y axis: `events`
   - Series: `event_selector`

8. Event selectors and token candidates
   - Query: `7367061`
   - Visualization: table
   - Query: `7367064`
   - Visualization: table

## Dune Agent Prompt

Create a private Dune dashboard named "Private Starknet Pool Monitor" for this pool:

0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a

Use these private queries:

- 7367048 for KPI cards: estimated TVL USD, token count, largest token balance USD
- 7367047 for the current balances and TVL table
- 7367049 for daily token inflows/outflows
- 7367050 for recent transfers
- 7367051 for direct pool contract transaction activity
- 7367061 for emitted event selector distribution
- 7367062 for daily event activity
- 7367063 for recent raw events
- 7367064 for token candidates seen in event payloads

Keep the dashboard private. Put KPI cards first, then a balances table, then daily flows, recent transfers, transaction activity, event activity, and token candidates. Add a note that direct ERC-20 balance-derived TVL returned zero rows for this contract and true Ekubo concentrated-liquidity TVL should come from the Ekubo indexer/API.
