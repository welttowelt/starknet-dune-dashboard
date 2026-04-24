-- Private Starknet overview: headline KPIs for the trailing 30 days.
with txs as (
  select *
  from starknet.transactions
  where block_date >= current_date - interval '30' day
),
daily as (
  select
    block_date,
    count(*) as tx_count,
    count(distinct sender_address) as active_senders,
    count_if(execution_status = 'SUCCEEDED') as succeeded_txs,
    sum(cast(actual_fee_amount as double)) / 1e18 as fees_token_units
  from txs
  group by 1
)
select
  sum(tx_count) as transactions_30d,
  sum(active_senders) as active_sender_days_30d,
  avg(tx_count) as avg_daily_transactions,
  avg(active_senders) as avg_daily_active_senders,
  100.0 * sum(succeeded_txs) / nullif(sum(tx_count), 0) as success_rate_pct,
  sum(fees_token_units) as fees_token_units_30d
from daily;
