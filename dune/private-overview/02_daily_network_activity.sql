-- Private Starknet overview: daily transactions and active senders.
select
  date_trunc('day', block_time) as day,
  count(*) as transactions,
  count(distinct sender_address) as active_senders
from starknet.transactions
where block_date >= current_date - interval '180' day
group by 1
order by 1;
