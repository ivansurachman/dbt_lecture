-- confirm
--  1. The total total_rentals in mart_customer_performance matches the number of rentals in stg_rentals.
--  2. The total lifetime_payment_total in mart_customer_performance matches the total amount in stg_payments.

select
    cp.customer_id,
    cp.total_rentals,
    cp.lifetime_payment_total
from {{ ref('mart_customer_performance') }} cp
where cp.total_rentals != (
    select 
        count(*) 
    from {{ ref('stg_rentals') }} 
    where customer_id = cp.customer_id)
and cp.lifetime_payment_total != (
    select 
        sum(amount) 
    from {{ ref('stg_payments') }} 
    where customer_id = cp.customer_id)
group by cp.customer_id, cp.total_rentals, cp.lifetime_payment_total
