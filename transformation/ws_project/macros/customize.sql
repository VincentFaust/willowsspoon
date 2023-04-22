{{% macro customize_schema(custom_alias, node) %}}
    {{% -if custom_alias == "staging"}}
        staging
    {{% else %}}
        {{target.schema}}_{{custom_alias}}
    {{%- endif -%}}
{{% endmacro %}}