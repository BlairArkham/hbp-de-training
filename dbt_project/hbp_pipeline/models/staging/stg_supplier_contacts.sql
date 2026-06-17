-- =================================================
-- Model: stg_supplier_contacts
-- Purpose: Clean supplier contacts from Fivetran
-- Layer: Bronze → Silver
-- =================================================

with source as (

    select *
    from {{ source('fivetran_supplier', 'SUPPLIER_CONTACTS') }}

),

cleaned as (

    select
        supplier_id,
        trim(supplier_name) as supplier_name,
        trim(contact_name) as contact_name,
        lower(contact_email) as contact_email,
        upper(country) as country,
        product_category,
        onboarded_at::date as onboarded_at,
        is_active::boolean as is_active

    from source

)

select *
from cleaned