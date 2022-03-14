{{
    config(
        materialized='incremental',
        unique_key='row_id'
    )
}}
with cte_all_data as 
(
   select distinct
      a.domain as domain,
      touch_category,
      touch,
      timestamp,
      call_conversion_time
   from
      {{ref('stg_all_touches')}} a 
      inner join
         {{ref('stg_shortlisted_domains')}} b 
         on a.domain = b.domain 
   where
      (
         timestamp < call_conversion_time 
         or call_conversion_time is null
      )
      and a.domain not in {{ var('domains_to_ignore') }} 
      and timestamp >= '{{ var('start_date') }}'
),
cte_ignore_invalid_events as 
(select * from cte_all_data where touch not in {{var('touches_to_ignore')}})
select
   * ,  concat_ws( domain, to_char(timestamp), touch) as row_id , current_timestamp() as updated_at
from
   cte_ignore_invalid_events
