with cte_autotrack_form_submit as 
(
   select
      anonymous_id,
      coalesce(context_traits_email, user_id) as email,
      timestamp,
      event,
      'form_submit' as conversion_type 
   From
      {{ source('marketing_website', 'form_submit') }} 
)
,
cte_webapp_signup as 
(
   select
      anonymous_id,
      coalesce(context_traits_email, user_id) as email,
      timestamp,
      'Identify' as event,
      'user_signed_up' as conversion_type 
   from
      {{ source('webapp', 'identifies') }} 
   where
      (
         first_login = true 
         or context_page_path = '/verify' 
         or context_library_name = 'analytics-node' 
      )
)
,
cte_all_conversions as 
(
   select
      anonymous_id, 
      {{get_domain_from_email('email')}} as domain,
       timestamp, 
       event, 
       conversion_type 
   from
      cte_autotrack_form_submit 
   union all
   select
      anonymous_id,
      {{get_domain_from_email('email')}} as domain, 
      timestamp, 
      event, 
      conversion_type 
   from
      cte_webapp_signup
)
select
   domain,
   conversion_type,
   min(timestamp) as timestamp 
from
   cte_all_conversions 
where
   domain is not null 
group by
   domain,
   conversion_type