-- Customer dimension table
with stg_customers as (
    select * from {{ ref('stg_customers') }}
),
stg_rentals as (
    select * from {{ ref('stg_rentals') }}
),
stg_payments as (
    select * from {{ ref('stg_payments') }}
)
select 
    customer_id,
    concat(first_name, ' ', last_name) as customer_name,
    case 
        when count(rental_id) is null then 0
        else count(rental_id)
    end as total_rentals,
    min(rental_at) as first_rented_at,
    max(rental_at) as last_rented_at,
    case 
        when sum(amount) is null then 0
        else sum(amount)
    end as lifetime_payment_total
from stg_customers
left join stg_rentals on stg_customers.customer_id = stg_rentals.customer_id
left join stg_payments on stg_customers.customer_id = stg_payments.customer_id
group by customer_id, customer_name