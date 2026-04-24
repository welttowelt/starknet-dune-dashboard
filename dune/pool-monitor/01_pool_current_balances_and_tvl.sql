-- Current estimated token balances and TVL for the watched Starknet pool.
-- Pool: https://voyager.online/contract/0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
with constants as (
  select
    0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a as pool_address,
    0x99cd8bde557814842a3121e8ddfd433a539b8c9f14bf31ebf108d12e6196e9 as transfer_selector
),
raw_transfers as (
  select
    e.block_time,
    e.block_date,
    e.transaction_hash,
    e.from_address as token_address,
    case
      when element_at(e.keys, 3) = c.pool_address then 1
      when element_at(e.keys, 2) = c.pool_address then -1
      when element_at(e.data, 2) = c.pool_address then 1
      when element_at(e.data, 1) = c.pool_address then -1
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
  where e.block_date >= date '2021-01-01'
    and element_at(e.keys, 1) = c.transfer_selector
    and (
      element_at(e.keys, 2) = c.pool_address
      or element_at(e.keys, 3) = c.pool_address
      or element_at(e.data, 1) = c.pool_address
      or element_at(e.data, 2) = c.pool_address
    )
),
balances as (
  select
    token_address,
    sum(direction * amount_raw) as balance_raw
  from raw_transfers
  where direction is not null
  group by 1
),
latest_prices as (
  select
    contract_address,
    symbol,
    decimals,
    price
  from prices.latest
  where blockchain = 'starknet'
)
select
  b.token_address,
  p.symbol,
  b.balance_raw,
  b.balance_raw / pow(10, coalesce(p.decimals, 18)) as balance,
  p.price as price_usd,
  b.balance_raw / pow(10, coalesce(p.decimals, 18)) * p.price as balance_usd
from balances b
left join latest_prices p
  on p.contract_address = b.token_address
where abs(b.balance_raw) > 0
order by balance_usd desc nulls last, abs(balance_raw) desc;
