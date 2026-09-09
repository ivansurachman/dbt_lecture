-- Staging model for the `category` table.
with source as (
    select * from {{ source('pagila', 'category') }}
)
select 
    category_id,
    name,
    last_update
from source