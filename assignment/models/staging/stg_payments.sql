-- Staging model for the `payment` table.

with source as (
    select * from {{ source('pagila', 'payment') }}
)
select 
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date as paid_at
from source