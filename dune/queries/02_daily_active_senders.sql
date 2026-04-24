-- Daily active Starknet senders for the trailing 90 days.
select
  date_trunc('day', block_time) as day,
  count(distinct sender_address) as active_senders
from starknet.transactions
where block_date >= current_date - interval '90' day
  and sender_address is not null
group by 1
order by 1;
