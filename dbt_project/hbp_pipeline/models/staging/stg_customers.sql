with source as (

    select *
    from {{ source('raw', 'CUSTOMERS') }}

),

cleaned as (

    select
        cast(customer_id as integer) as customer_id,

        trim(first_name) as first_name,
        trim(last_name) as last_name,

        lower(trim(email)) as email,

        upper(trim(country)) as country,

        cast(created_at as date) as created_at,

        lower(is_active) = 'true' as is_active

    from source
)

select *
from cleaned