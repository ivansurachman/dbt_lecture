-- Mart model for daily revenue
with fact_payments as (
    select * from {{ ref('fact_payments') }}
)
select
    p.paid_date,
    p.store_id,
    count(payment_id) as total_payments,
    count(distinct customer_id) as unique_customers,
    sum(amount) as total_revenue
from fact_payments p
group by p.paid_date, p.store_id