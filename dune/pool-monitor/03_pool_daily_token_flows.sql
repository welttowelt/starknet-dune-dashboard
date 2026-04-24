-- Daily token inflows and outflows for the watched Starknet pool.
with constants as (
  select
    0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a as pool_address,
    0x99cd8bde557814842a3121e8ddfd433a539b8c9f14bf31ebf108d12e6196e9 as transfer_selector
),
transfers as (
  select
    date_trunc('day', e.block_time) as day,
    e.from_address as token_address,
    case
      when element_at(e.keys, 3) = c.pool_address then 'in'
      when element_at(e.keys, 2) = c.pool_address then 'out'
      when element_at(e.data, 2) = c.pool_address then 'in'
      when element_at(e.data, 1) = c.pool_address then 'out'
    end as direction,
    case
      when element_at(e.keys, 2) = c.pool_address or element_at(e.keys, 3) = c.pool_address
        then cast(varbinary_to_uint256(element_at(e.data, 1)) as double)
          + cast(coalesce(varbinary_to_uint256(element_at(e.data, 2)), uint256 '0') as double) * pow(2, 128)
      else cast(varbinary_to_uint256(element_at(e.data, 3)) as double)
        + cast(coalesce(varbinary_to_uint256(element_at(e.data, 4)), uint256 '0') as double) * pow(2, 128)
    end as amount_raw
  from starknet.events e
  cross join constants c
  where e.block_date >= current_date - interval '180' day
    and element_at(e.keys, 1) = c.transfer_selector
    and (
      element_at(e.keys, 2) = c.pool_address
      or element_at(e.keys, 3) = c.pool_address
      or element_at(e.data, 1) = c.pool_address
      or element_at(e.data, 2) = c.pool_address
    )
),
prices as (
  select
    contract_address,
    symbol,
    decimals,
    price,
    date_trunc('day', timestamp) as day
  from prices.day
  where blockchain = 'starknet'
    and timestamp >= current_date - interval '180' day
)
select
  t.day,
  t.token_address,
  p.symbol,
  t.direction,
  sum(t.amount_raw / pow(10, coalesce(p.decimals, 18))) as amount,
  sum(t.amount_raw / pow(10, coalesce(p.decimals, 18)) * p.price) as amount_usd,
  count(*) as transfer_events
from transfers t
left join prices p
  on p.contract_address = t.token_address
  and p.day = t.day
where t.direction is not null
group by 1, 2, 3, 4
order by 1 desc, amount_usd desc nulls last;
