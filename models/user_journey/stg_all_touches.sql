
select domain, 'signup' as touch_category, conversion_type as touch, timestamp from {{ ref('stg_conversions') }}
union all 
select domain, 'tracks' as touch_category, context_page_path as touch, timestamp from {{ ref('stg_traffic') }}
union all 
select domain, 'marketing' as touch_category, event as touch, timestamp from {{ ref('marketing_touches') }}
union all 
select domain, 'sales' as touch_category, event as touch, timestamp from {{ ref('stg_sales_touches') }}