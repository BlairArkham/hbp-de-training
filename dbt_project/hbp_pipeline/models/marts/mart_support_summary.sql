-- =========================================================
-- Model: mart_support_summary
-- Layer: GOLD (MART)
-- Purpose: Combine customer spend + support ticket behavior
--          to classify customer health for commercial teams
-- =========================================================

with customer_base as (

    select *
    from {{ ref('mart_customer_summary') }}

),

ticket_metrics as (

    select *
    from {{ ref('int_ticket_metrics') }}

),

final as (

    select

        -- =========================
        -- CUSTOMER IDENTIFIER
        -- =========================
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,

        -- =========================
        -- BUSINESS METRICS (ORDERS)
        -- =========================
        c.total_spend_pence,
        c.spend_rank,
        c.spend_dense_rank,

        -- =========================
        -- SUPPORT METRICS
        -- =========================
        t.total_tickets,
        t.open_tickets,
        t.resolved_tickets,
        t.high_priority_tickets,
        t.avg_days_to_resolve,

        -- =========================
        -- CUSTOMER HEALTH LOGIC
        -- =========================
        case

            -- High value + no open issues
            when c.total_spend_pence >= 10000
                 and coalesce(t.open_tickets, 0) = 0
            then 'HEALTHY'

            -- High value + some issues
            when c.total_spend_pence >= 10000
                 and coalesce(t.open_tickets, 0) between 1 and 2
            then 'AT_RISK'

            -- High value + many open tickets
            when c.total_spend_pence >= 10000
                 and coalesce(t.open_tickets, 0) > 2
            then 'CRITICAL'

            -- Low value + many issues
            when c.total_spend_pence < 10000
                 and coalesce(t.open_tickets, 0) > 2
            then 'UNSTABLE'

            -- Default category
            else 'STANDARD'

        end as customer_health,

        -- =========================
        -- METADATA
        -- =========================
        current_timestamp() as dbt_updated_at

    from customer_base c

    left join ticket_metrics t
        on c.customer_id = t.customer_id

)

select *
from final