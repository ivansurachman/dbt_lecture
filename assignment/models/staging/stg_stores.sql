-- Staging model for store data
with source as (
    select * from {{ source('pagila', 'store') }}
)
select 
    store_id,
    manager_staff_id,
    address_id,
    last_update
from source