-- =================================================
-- Model: int_ticket_metrics
-- Purpose: Customer-level ticket metrics
-- Layer: Intermediate
-- =================================================

with tickets as (

    select *
    from {{ ref('stg_support_tickets') }}

)

select

    customer_id,

    count(*) as total_tickets,

    count_if(status = 'open')
        as open_tickets,

    count_if(status = 'resolved')
        as resolved_tickets,

    count_if(status = 'closed')
        as closed_tickets,

    count_if(priority = 'high')
        as high_priority_tickets,

    avg(

        case
            when status in (
                'resolved',
                'closed'
            )
            then days_to_resolve
        end

    ) as avg_days_to_resolve

from tickets

group by customer_id