-- Event selector distribution emitted by the watched pool contract.
select
  element_at(keys, 1) as event_selector,
  count(*) as events,
  min(block_time) as first_seen,
  max(block_time) as last_seen
from starknet.events
where from_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
group by 1
order by events desc;
