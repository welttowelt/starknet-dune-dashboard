-- Private Starknet overview: execution status over the trailing 30 days.
select
  execution_status,
  count(*) as transactions,
  100.0 * count(*) / sum(count(*)) over () as share_pct
from starknet.transactions
where block_date >= current_date - interval '30' day
group by 1
order by 2 desc;
