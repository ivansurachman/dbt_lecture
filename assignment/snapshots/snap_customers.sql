-- Snap table for customers
{% snapshot customers_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='timestamp' | 'check',
    check_cols=['customer_name'],
    updated_at='last_update'
  )
}}

select  
    customer_id,
    concat(first_name, ' ', last_name) as customer_name
from {{ ref('stg_customers') }}

{% endsnapshot %}