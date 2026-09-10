-- Snap table for films
{% snapshot films_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='film_id',
    strategy='timestamp' | 'check',
    check_cols=['title', 'rental_rate', 'rating', 'description'],
    updated_at='last_update'
  )
}}

select  
    film_id,
    title,
    rental_rate,
    rating,
    description
from {{ ref('stg_films') }}

{% endsnapshot %}