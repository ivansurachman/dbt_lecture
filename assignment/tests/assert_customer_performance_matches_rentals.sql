-- confirm
--  1. The total total_rentals in mart_customer_performance matches the number of rentals in stg_rentals.
--  2. The total lifetime_payment_total in mart_customer_performance matches the total amount in stg_payments.

with stg_rentals as (
    select * from {{ ref('stg_rentals') }}
),
metrics_rental as (
    select 
        customer_id,
        count(*) as total_rentals
    from stg_rentals
    group by customer_id
),
stg_payments as (
    select * from {{ ref('stg_payments') }}
),
metrics_payment as (
    select 
        customer_id,
        sum(amount) as lifetime_payment_total
    from stg_payments
    group by customer_id
)

select
    cp.total_rentals,
    cp.lifetime_payment_total,
    mpr.total_rentals as expected_total_rentals,
    mpp.lifetime_payment_total as expected_lifetime_payment_total
from {{ ref('mart_customer_performance') }} cp
join metrics_rental mpr on cp.customer_id = mpr.customer_id
join metrics_payment mpp on cp.customer_id = mpp.customer_id
where cp.total_rentals != mpr.total_rentals
or cp.lifetime_payment_total != mpp.lifetime_payment_total
or cp.total_rentals is null
or cp.lifetime_payment_total is null
