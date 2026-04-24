-- Private Starknet overview: calldata vs blob usage by day.
select
  date_trunc('day', block_time) as day,
  block_l1_da_mode,
  count(*) as transactions
from starknet.transactions
where block_date >= current_date - interval '180' day
  and block_l1_da_mode is not null
group by 1, 2
order by 1, 2;
