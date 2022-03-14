with cte_traffic_raw as 
(
   select
      p.anonymous_id as anonymous_id,
      coalesce(m.email, context_traits_email, user_id) as email,
      context_page_path,
      timestamp 
   From
      {{ source('marketing_website', 'pages') }} p 		-- Main Webpage
      left outer join
         {{ ref('identities') }} m 
         on p.anonymous_id = m.anonymous_id 
   where
      timestamp >= to_date('{{ var('start_date') }}') 
   UNION ALL
   select
      p.anonymous_id as anonymous_id,
      coalesce(m.email, context_traits_email, user_id) as email,
      context_page_path,
      timestamp 
   From
      {{ source('webapp', 'pages') }} p 		-- APP Webpage
      left outer join
         {{ ref('identities') }} m 
         on p.anonymous_id = m.anonymous_id 
   where
      timestamp >= to_date('{{ var('start_date') }}') 
)
,
cte_traffic_processed as 
(
   select
      {{get_domain_from_email('email')}} as domain,
      {{ page_path_to_page_name('context_page_path')}} as context_page_path,
      timestamp 
   from
      cte_traffic_raw 
   where
      email is not null 
      and context_page_path is not null
)
select
   domain,
   case
      when
         context_page_path in {{ var('top_tracks_sources') }}
      then
         context_page_path 
      else
         '{{ var('default_tracks_touch') }}' 
   end
   as context_page_path, timestamp 
from
   cte_traffic_processed