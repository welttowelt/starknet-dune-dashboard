-- Daily Starknet transaction count for the trailing 90 days.
select
  date_trunc('day', block_time) as day,
  count(*) as transactions
from starknet.transactions
where block_date >= current_date - interval '90' day
group by 1
order by 1;
