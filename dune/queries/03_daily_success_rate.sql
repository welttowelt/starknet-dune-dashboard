-- Daily Starknet transaction success rate for the trailing 90 days.
select
  date_trunc('day', block_time) as day,
  count_if(execution_status = 'SUCCEEDED') as succeeded_transactions,
  count(*) as total_transactions,
  100.0 * count_if(execution_status = 'SUCCEEDED') / nullif(count(*), 0) as success_rate_pct
from starknet.transactions
where block_date >= current_date - interval '90' day
group by 1
order by 1;
