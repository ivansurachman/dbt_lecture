with daily_payments as (
    select
        p.paid_at::date as paid_date,
        i.store_id,
        sum(p.amount) as total_revenue,
        count(p.payment_id) as total_payments
    from {{ ref('stg_payments') }} p
    join {{ ref('stg_rentals') }} r on r.rental_id = p.rental_id
    join {{ ref('stg_inventory') }} i on i.inventory_id = r.inventory_id
    group by 1,2
)
select 
    dr.total_revenue,
    dr.total_payments,
    dp.total_revenue as expected_total_revenue,
    dp.total_payments as expected_total_payments
from {{ ref('mart_daily_revenue') }} dr
join daily_payments dp on dr.paid_date = dp.paid_date and dr.store_id = dp.store_id
where dr.total_revenue != dp.total_revenue
or dr.total_payments != dp.total_payments
or dr.total_revenue is null
or dr.total_payments is null