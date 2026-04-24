-- Token-like addresses observed in the pool contract's events.
-- This is useful for identifying the assets involved before protocol-specific decoding.
with event_values as (
  select
    block_time,
    transaction_hash,
    value
  from starknet.events
  cross join unnest(keys) as t(value)
  where from_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
    and block_date >= current_date - interval '180' day

  union all

  select
    block_time,
    transaction_hash,
    value
  from starknet.events
  cross join unnest(data) as t(value)
  where from_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
    and block_date >= current_date - interval '180' day
)
select
  value as candidate_address,
  p.symbol,
  p.price as latest_price_usd,
  count(*) as appearances,
  count(distinct transaction_hash) as transactions,
  max(block_time) as last_seen
from event_values e
left join prices.latest p
  on p.blockchain = 'starknet'
  and p.contract_address = e.value
group by 1, 2, 3
having p.symbol is not null
order by appearances desc;
