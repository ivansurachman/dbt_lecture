-- Snap table for customers
select  
    customer_id,
    concat(first_name, ' ', last_name) as customer_name
from {{ ref('stg_customers') }}