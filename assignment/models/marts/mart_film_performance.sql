-- Mart model for film performance
with dim_films as (
    select * from {{ ref('dim_films') }}
),
fact_payments as (
    select * from {{ ref('fact_payments') }}
)
select
    f.film_id,
    f.title,
    f.category,
    f.rental_rate,
    f.inventory_count,
    f.times_rented,
    coalesce(sum(p.amount), 0) as total_revenue
from dim_films f
join fact_payments p on f.film_id = p.film_id
group by f.film_id, f.title, f.category, f.rental_rate, f.inventory_count, f.times_rented