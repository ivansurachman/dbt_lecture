select
    dr.paid_date,
    dr.total_revenue,
    dr.total_payments
from {{ ref('mart_daily_revenue') }} dr
where dr.total_revenue != (
    select 
        sum(amount) 
    from {{ ref('stg_payments') }} 
    where date(payment_date) = dr.revenue_date)
and dr.total_payments != (
    select 
        count(*) 
    from {{ ref('stg_payments') }} 
    where date(payment_date) = dr.revenue_date)