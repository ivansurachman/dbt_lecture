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
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    case 
        when count(r.rental_id) is null then 0
        else count(r.rental_id)
    end as total_rentals,
    min(r.rental_at) as first_rented_at,
    max(r.rental_at) as last_rented_at,
    case 
        when sum(p.amount) is null then 0
        else sum(p.amount)
    end as lifetime_payment_total
from stg_customers c
left join stg_rentals r on c.customer_id = r.customer_id
left join stg_payments p on c.customer_id = p.customer_id
group by c.customer_id, customer_name