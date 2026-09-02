-- Staging model for the `rental` table.

with source as (
    select * from {{ source('pagila', 'rental') }}
)
select 
    rental_id,
    customer_id,
    inventory_id,
    staff_id,
    rental_at,
    returned_at
from source