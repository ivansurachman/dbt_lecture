-- Snap table for films
select  
    film_id,
    title,
    rental_rate,
    rating,
    description
from {{ ref('stg_films') }}