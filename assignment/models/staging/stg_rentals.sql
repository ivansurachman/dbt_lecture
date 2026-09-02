-- Staging model for the `rental` table.

with source as (
    select * from {{ source('pagila', 'rental') }}
)
select 
    rental_id,
    customer_id,
    inventory_id,
    staff_id,
    rental_date as rental_at,
    return_date as returned_at,
    last_update
from source