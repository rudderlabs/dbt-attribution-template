with cte_paid_domains as 
(
   select distinct
      domain 
   from
      {{ source('analytics', 'agg_domain_summary') }} 
   where
      lower(account_type) not like '%free%'
)
,
cte_call_scheduled_domains as 
(
   select
      domain,
      call_conversion_time 
   from
      {{ ref('feat_call_setup_time') }}
)
,
cte_all_domains as 
(
   select distinct
      domain 
   from
      {{ ref('stg_all_touches') }}
)
select
   all_domains.domain as domain,
   call_scheduled.call_conversion_time as call_conversion_time 
from
   cte_all_domains all_domains 
   left join
      cte_call_scheduled_domains call_scheduled 
      on all_domains.domain = call_scheduled.domain 
   left join
      cte_paid_domains paid 
      on all_domains.domain = paid.domain 
where
   call_scheduled.domain is not null 
   or 
   paid.domain is null -- Ignoring current pro/enterprise accounts
   