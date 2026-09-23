SELECT *
FROM {{ source('consumo', 'dim_cliente') }}