-- Private Starknet overview: daily fees grouped by fee unit.
select
  date_trunc('day', block_time) as day,
  actual_fee_unit,
  sum(cast(actual_fee_amount as double)) / 1e18 as fee_volume_token_units
from starknet.transactions
where block_date >= current_date - interval '180' day
  and actual_fee_amount is not null
group by 1, 2
order by 1, 2;
