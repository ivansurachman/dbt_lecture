-- Fact table for payments
with stg_payments as (
    select * from {{ ref('stg_payments') }}
),
dim_customers as (
    select * from {{ ref('dim_customers') }}
),
stg_rentals as (
    select * from {{ ref('stg_rentals') }}
),
stg_inventory as (
    select * from {{ ref('stg_inventory') }}
),
dim_film as (
    select * from {{ ref('dim_films') }}
)
select
    p.payment_id,
    p.paid_at,
    p.paid_at::date as paid_date,
    p.customer_id,
    c.customer_name,
    p.staff_id,
    i.store_id,
    p.rental_id,
    i.film_id,
    f.title as film_title,
    p.amount
from stg_payments p
left join dim_customers c on p.customer_id = c.customer_id
left join stg_rentals r on p.rental_id = r.rental_id
left join stg_inventory i on r.inventory_id = i.inventory_id
left join dim_film f on i.film_id = f.film_id