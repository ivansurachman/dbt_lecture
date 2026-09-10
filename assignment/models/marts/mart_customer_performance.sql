-- Mart model for customer performance
with fact_payments as (
    select * from {{ ref('fact_payments') }}
),
with dim_customers as (
    select * from {{ ref('dim_customers') }}
)
select
    c.customer_id,
    c.customer_name,
    c.total_rentals,
    c.first_rented_at,
    c.last_rented_at,
    c.lifetime_payment_total,
    c.lifetime_payment_total / nullif(c.total_rentals, 0) as average_payment_value
from dim_customers c
left join fact_payments p on c.customer_id = p.customer_id
