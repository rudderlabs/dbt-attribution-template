{% macro get_domain_from_email(email_col) %}
  case
         when
            lower({{email_col}}) like any {{ var('generic_domain_patterns') }} 
         then
            lower({{email_col}})
         else
            lower(split_part({{email_col}}, '@', 2)) 
      end
{% endmacro %}