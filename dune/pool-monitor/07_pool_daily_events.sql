-- Daily emitted event count for the watched pool contract.
select
  date_trunc('day', block_time) as day,
  element_at(keys, 1) as event_selector,
  count(*) as events,
  count(distinct transaction_hash) as transactions
from starknet.events
where from_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
  and block_date >= current_date - interval '180' day
group by 1, 2
order by 1 desc, events desc;
