WITH pedidos AS (
    SELECT 
        id_pedido,
        data_pedido,
        id_cliente,
        canal_venda,
        endereco_entrega
    FROM {{ source('consumo', 'pedidos_desnormalizados') }}
),

vendas AS (
    SELECT 
        sk_venda,
        id_pedido_bk AS id_pedido,
        sk_produto AS id_produto,
        quantidade,
        preco_unitario,
        custo_unitario,
        (quantidade * preco_unitario) AS receita_bruta,
        (quantidade * custo_unitario) AS custo_total,
        ((quantidade * preco_unitario) - (quantidade * custo_unitario)) AS lucro_bruto
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
    v.custo_unitario,
    v.receita_bruta,
    v.custo_total,
    v.lucro_bruto
FROM vendas v
LEFT JOIN pedidos p ON v.id_pedido = p.id_pedido