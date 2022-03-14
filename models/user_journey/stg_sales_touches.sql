with cte_snowflake_data as 
(
   select
      case
         when
            type like any ('Call', '%demo%') 
            or tasksubtype = 'Call' 
         then
            'call' 
         when
            type = 'Email' 
            or tasksubtype = 'Email' 
         then
            case
               when
                  subject like '%[In]%' 
               then
                  'sales_email_in' 
               else
                  'sales_email_out' 
            end
            else
               null 
      end
      as event, l.email  as email, t.activitydate as timestamp 
   from
      {{ source('salesforce', 'task') }} t 
      left outer join
         {{ source('salesforce', 'lead') }} l 
         on t.whoid = l.id 
)
select
   {{get_domain_from_email('email')}} as domain,
   event,
   timestamp 
from
   cte_snowflake_data 
where
   event is not null