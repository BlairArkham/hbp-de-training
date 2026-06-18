-- =================================================
-- Model: stg_support_tickets
-- Purpose: Clean support ticket data and apply
--           standard business transformations.
-- Layer: Silver
-- =================================================

with source as (

    select *
    from {{ source('raw', 'SUPPORT_TICKETS') }}

),

cleaned as (

    select

        trim(ticket_id) as ticket_id,

        customer_id::integer as customer_id,

        trim(subject) as subject,

        initcap(trim(category)) as category,

        lower(trim(priority)) as priority,

        lower(trim(status)) as status,

        to_date(created_at, 'DD/MM/YYYY') as created_at,

        case
            when resolved_at is null
                 or trim(resolved_at) = ''
            then null

            else to_date(
                resolved_at,
                'DD/MM/YYYY'
            )
        end as resolved_at,

        trim(agent_name) as agent_name,

        datediff(
            day,
            to_date(created_at, 'DD/MM/YYYY'),

            case
                when resolved_at is null
                     or trim(resolved_at) = ''
                then null

                else to_date(
                    resolved_at,
                    'DD/MM/YYYY'
                )
            end
        ) as days_to_resolve

    from source

)

select *
from cleaned