{% macro generate_schema_name(custom_alias, node) -%}
    {%- if custom_alias == "staging" -%}
        staging
    {%- elif custom_alias == "serving" -%}
        serving
    {%- else -%}
        {{ target.schema }}_{{ custom_alias }}
    {%- endif -%}
{% endmacro %}
