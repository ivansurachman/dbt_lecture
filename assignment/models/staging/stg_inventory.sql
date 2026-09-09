-- Staging model for inventory data
with source as (
    select * from {{ source('pagila', 'inventory') }}
)
select 
    inventory_id,
    film_id,
    store_id,
    last_update
from source