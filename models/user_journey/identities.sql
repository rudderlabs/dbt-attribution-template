
Select distinct anonymous_id, lower(coalesce(context_traits_email, user_id)) as email
 From  {{ source('webapp', 'identifies') }} where anonymous_id is not null 
 UNION all 
  Select distinct anonymous_id, lower(coalesce(context_traits_email, user_id)) as email
  From {{ source('marketing_website', 'identifies') }}
  where anonymous_id is not null

