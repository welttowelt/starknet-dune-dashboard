-- Recent token transfers touching the watched Starknet pool.
with constants as (
  select
    0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a as pool_address,
    0x99cd8bde557814842a3121e8ddfd433a539b8c9f14bf31ebf108d12e6196e9 as transfer_selector
)
select
  e.block_time,
  e.transaction_hash,
  e.from_address as token_address,
  p.symbol,
  case
    when element_at(e.keys, 3) = c.pool_address then 'in'
    when element_at(e.keys, 2) = c.pool_address then 'out'
    when element_at(e.data, 2) = c.pool_address then 'in'
    when element_at(e.data, 1) = c.pool_address then 'out'
  end as direction,
  case
    when element_at(e.keys, 2) = c.pool_address or element_at(e.keys, 3) = c.pool_address
      then element_at(e.keys, 2)
    else element_at(e.data, 1)
  end as from_account,
  case
    when element_at(e.keys, 2) = c.pool_address or element_at(e.keys, 3) = c.pool_address
      then element_at(e.keys, 3)
    else element_at(e.data, 2)
  end as to_account,
  case
    when element_at(e.keys, 2) = c.pool_address or element_at(e.keys, 3) = c.pool_address
      then (
        cast(varbinary_to_uint256(element_at(e.data, 1)) as double)
          + cast(coalesce(varbinary_to_uint256(element_at(e.data, 2)), uint256 '0') as double) * pow(2, 128)
      ) / pow(10, coalesce(p.decimals, 18))
    else (
      cast(varbinary_to_uint256(element_at(e.data, 3)) as double)
        + cast(coalesce(varbinary_to_uint256(element_at(e.data, 4)), uint256 '0') as double) * pow(2, 128)
      ) / pow(10, coalesce(p.decimals, 18))
  end as amount,
  p.price as price_usd
from starknet.events e
cross join constants c
left join prices.latest p
  on p.blockchain = 'starknet'
  and p.contract_address = e.from_address
where e.block_date >= current_date - interval '30' day
  and element_at(e.keys, 1) = c.transfer_selector
  and (
    element_at(e.keys, 2) = c.pool_address
    or element_at(e.keys, 3) = c.pool_address
    or element_at(e.data, 1) = c.pool_address
    or element_at(e.data, 2) = c.pool_address
  )
order by e.block_time desc
limit 200;
