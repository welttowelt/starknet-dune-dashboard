-- Private Starknet overview: most touched contracts over the trailing 30 days.
select
  contract_address,
  count(*) as transactions,
  count(distinct sender_address) as unique_senders
from starknet.transactions
where block_date >= current_date - interval '30' day
  and contract_address is not null
group by 1
order by 2 desc
limit 50;
