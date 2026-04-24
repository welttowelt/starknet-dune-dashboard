-- Current estimated TVL summary for the watched Starknet pool.
with balances as (
  select *
  from query_7367043
)
select
  count(*) as token_count,
  sum(balance_usd) as estimated_tvl_usd,
  max(balance_usd) as largest_token_balance_usd
from balances;
