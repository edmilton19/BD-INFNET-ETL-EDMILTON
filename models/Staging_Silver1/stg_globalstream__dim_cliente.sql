SELECT
    CAST(sk_cliente AS STRING) AS sk_cliente,
    CAST(id_cliente_bk AS STRING) AS id_cliente_bk,
    UPPER(TRIM(nome_cliente)) AS nome_cliente,
    LOWER(TRIM(email)) AS email_cliente,
    UPPER(TRIM(cidade)) AS cidade_cliente,
    UPPER(TRIM(estado)) AS estado_cliente
FROM {{ source('consumo', 'dim_cliente') }}