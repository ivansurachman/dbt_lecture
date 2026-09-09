-- Film dimension table
with stg_films as (
    select * from {{ ref('stg_films') }}
),
ratings_desc as (
    select 
        rating,
        rating_description
    from {{ ref('rating_descriptions') }}
),
film_category as (
    select * from {{ ref('stg_film_categories') }}
),
categories as (
    select * from {{ ref('stg_categories') }}
),
transformed_films_category as (
    select
        fc.film_id,
        string_agg(distinct c.name, ', ' order by c.name) as category
    from film_category fc
    left join categories c on fc.category_id = c.category_id
    group by fc.film_id
),
inventory as (
    select 
        f.film_id,
        case 
            when count(i.inventory_id) is null then 0
            else count(i.inventory_id)
        end as inventory_count
    from stg_films f
    left join {{ ref('stg_inventory') }} i on f.film_id = i.film_id
    group by f.film_id
),
rentals as (
    select 
        f.film_id,
        case 
            when count(r.rental_id) is null then 0
            else count(r.rental_id)
        end as times_rented
    from stg_films f
    left join {{ ref('stg_inventory') }} i on f.film_id = i.film_id
    left join {{ ref('stg_rentals') }} r on i.inventory_id = r.inventory_id
    group by f.film_id
),
is_available as (
    select 
        f.film_id,
        case 
            when count(i.inventory_id) > 0 then true
            else false
        end as is_available
    from stg_films f
    left join {{ ref('stg_inventory') }} i on f.film_id = i.film_id
    group by f.film_id
)
select
    f.film_id,
    f.title,
    tfc.category,
    f.rating,
    rd.rating_description,
    f.rental_rate,
    i.inventory_count,
    r.times_rented,
    ia.is_available
from stg_films f
left join ratings_desc rd on f.rating = rd.rating
left join transformed_films_category tfc on f.film_id = tfc.film_id
left join inventory i on f.film_id = i.film_id
left join rentals r on f.film_id = r.film_id
left join is_available ia on f.film_id = ia.film_id