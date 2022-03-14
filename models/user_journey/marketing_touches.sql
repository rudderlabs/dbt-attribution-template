select
   case
      when
         lower(user_id) like any {{ var('generic_domain_patterns') }} 
      then
         lower(user_id) 
      else
         lower(split_part(user_id, '@', 2)) 
   end
   as domain, 
   case
      when
         lower(event) like '%sent%' 
      then
         concat_ws('_', event_type, 'sent') 
      when
         lower(event) like '%open%' 
      then
         concat_ws('_', event_type, 'opened') 
      when
         lower(event) like '%click%' 
      then
         concat_ws('_', event_type, 'clicked') 
   end
   as event, timestamp 
from
   (
      select
         event,
         user_id,
         case
            when
               nvl(newsletter_id, 0) > 0 
            then
               'marketing_newsletter' 
            when
               nvl(campaign_id, 0) > 0 
            then
               'marketing_campaign' 
            else
               'marketing_others' 
         end
         as event_type, timestamp 
      From
         {{source('eric_db', 'email_sent') }} 
      union all
      select
         event,
         user_id,
         case
            when
               nvl(newsletter_id, 0) > 0 
            then
               'marketing_newsletter' 
            when
               nvl(campaign_id, 0) > 0 
            then
               'marketing_campaign' 
            else
               'marketing_others' 
         end
         as event_type, timestamp 
      From
         {{source('eric_db', 'email_opened') }} 
      union all
      select
         event,
         user_id,
         case
            when
               nvl(newsletter_id, 0) > 0 
            then
               'marketing_newsletter' 
            when
               nvl(campaign_id, 0) > 0 
            then
               'marketing_campaign' 
            else
               'marketing_others' 
         end
         as event_type, timestamp 
      From
         {{source('eric_db', 'email_link_clicked') }} 
   )