with daily_payments as (
    select
        paid_at::date as paid_date,
        sum(amount) as total_revenue,
        count(distinct payment_id) as total_payments
    from {{ ref('stg_payments') }}
    group by 1
)

select 
    dr.total_revenue,
    dr.total_payments,
    dp.total_revenue as expected_total_revenue,
    dp.total_payments as expected_total_payments
from {{ ref('mart_daily_revenue') }} dr
join daily_payments dp on dr.paid_date = dp.paid_date
where dr.total_revenue != dp.total_revenue
or dr.total_payments != dp.total_payments
or dr.total_revenue is null
or dr.total_payments is null