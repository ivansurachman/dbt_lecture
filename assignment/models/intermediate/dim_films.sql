-- Film dimension table
with stg_films as (
    select * from {{ ref('stg_films') }}
),
ratings_desc as (
    select 
        rating,
        description
    from {{ ref('rating_descriptions') }}
),
stg_film_category as (
    select * from {{ ref('stg_film_categories') }}
),
stg_categories as (
    select * from {{ ref('stg_categories') }}
),
stg_inventory as (
    select * from {{ ref('stg_inventory') }}
),
stg_rentals as (
    select * from {{ ref('stg_rentals') }}
)
select
    f.film_id,
    f.title,
    string_agg(distinct c.name, ', ' order by c.name) as category,
    f.rating,
    rd.description as rating_description,
    f.rental_rate,
    coalesce(count(i.inventory_id), 0) as inventory_count,
    coalesce(count(r.rental_id), 0) as times_rented,
    case 
        when count(i.inventory_id) > 0 then true
        else false
    end as is_available
from stg_films f
left join ratings_desc rd on f.rating = rd.rating
left join stg_film_category fc on f.film_id = fc.film_id
left join stg_categories c on fc.category_id = c.category_id
left join stg_inventory i on f.film_id = i.film_id
left join stg_rentals r on i.inventory_id = r.inventory_id
group by f.film_id, f.title, f.rating, rd.rating_description, f.rental_rate