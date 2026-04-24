-- Transactions directly targeting or emitted by the watched pool contract.
select
  date_trunc('day', block_time) as day,
  type,
  execution_status,
  count(*) as transactions,
  count(distinct sender_address) as active_senders,
  sum(cast(actual_fee_amount as double)) / 1e18 as fee_token_units
from starknet.transactions
where block_date >= current_date - interval '180' day
  and (
    contract_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
    or sender_address = 0x040337b1af3c663e86e333bab5a4b28da8d4652a15a69beee2b677776ffe812a
  )
group by 1, 2, 3
order by 1 desc, transactions desc;
