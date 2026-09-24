WITH pedidos AS (
    SELECT 
        CAST(id_pedido AS STRING) AS id_pedido,
        CAST(data_pedido AS DATE) AS data_pedido,
        CAST(id_cliente AS STRING) AS id_cliente,
        UPPER(TRIM(canal_venda)) AS canal_venda,
        endereco_entrega
    FROM {{ source('consumo', 'pedidos_desnormalizados') }}
),

vendas AS (
    SELECT 
        CAST(sk_venda AS STRING) AS sk_venda,
        CAST(id_pedido_bk AS STRING) AS id_pedido,
        CAST(sk_produto AS STRING) AS id_produto,
        CAST(quantidade AS INT64) AS quantidade,
        CAST(preco_unitario AS NUMERIC) AS preco_unitario,
        ROUND(CAST(quantidade * preco_unitario AS NUMERIC), 2) AS receita_bruta
    FROM {{ source('consumo', 'fato_vendas') }}
)

SELECT 
    v.sk_venda,
    v.id_pedido,
    p.data_pedido,
    p.id_cliente,
    v.id_produto,
    p.canal_venda,
    v.quantidade,
    v.preco_unitario,
    v.receita_bruta
FROM vendas v
LEFT JOIN pedidos p ON v.id_pedido = p.id_pedido