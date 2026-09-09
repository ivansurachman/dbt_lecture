-- Bridge table: which categories each film belongs to.
-- This is a staging model that extracts data from the `film_category` table in the source database.
with source as (

    select * from {{ source('pagila', 'film_category') }}

)
select 
    film_id,
    category_id,
    last_update
from source