-- Recent raw events emitted by the watched pool contract for protocol-specific decoding.
select
  block_time,
  transaction_hash,
  event_index,
  element_at(keys, 1) as event_selector,
  keys,
  data,
  class_hash
from starknet.events
where from_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
order by block_time desc, event_index
limit 500;
