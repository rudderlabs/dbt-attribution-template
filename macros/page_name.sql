{% macro page_path_to_page_name(column_name, delimiter='/') %}
    split_part(trim({{column_name}}, '{{delimiter}}'),'{{delimiter}}', 1)
{% endmacro %}

