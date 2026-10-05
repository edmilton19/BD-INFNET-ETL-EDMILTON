WITH pedidos_mock AS (
    SELECT 'PED_001' AS id_pedido, CAST('2026-09-01' AS DATE) AS data_pedido, 'CUST_101' AS id_cliente, 'WEB' AS canal_venda UNION ALL
    SELECT 'PED_002' AS id_pedido, CAST('2026-09-02' AS DATE) AS data_pedido, 'CUST_102' AS id_cliente, 'LOJA FISICA' AS canal_venda UNION ALL
    SELECT 'PED_003' AS id_pedido, CAST('2026-09-03' AS DATE) AS data_pedido, 'CUST_103' AS id_cliente, 'APP' AS canal_venda UNION ALL
    SELECT 'PED_004' AS id_pedido, CAST('2026-09-04' AS DATE) AS data_pedido, 'CUST_104' AS id_cliente, 'WEB' AS canal_venda UNION ALL
    SELECT 'PED_005' AS id_pedido, CAST('2026-09-05' AS DATE) AS data_pedido, 'CUST_105' AS id_cliente, 'LOJA FISICA' AS canal_venda
),

clientes AS (
    SELECT 
        sk_cliente,
        id_cliente_bk,
        nome_cliente,
        cidade_cliente,
        estado_cliente
    FROM {{ ref('stg_globalstream__dim_cliente') }}
),

vendas_mock AS (
    SELECT 'SK_001' AS sk_venda, 'PED_001' AS id_pedido, 'PROD_A' AS id_produto, 2 AS quantidade, CAST(1200.00 AS NUMERIC) AS preco_unitario UNION ALL
    SELECT 'SK_002' AS sk_venda, 'PED_002' AS id_pedido, 'PROD_B' AS id_produto, 1 AS quantidade, CAST(850.00 AS NUMERIC) AS preco_unitario UNION ALL
    SELECT 'SK_003' AS sk_venda, 'PED_003' AS id_pedido, 'PROD_C' AS id_produto, 3 AS quantidade, CAST(1500.00 AS NUMERIC) AS preco_unitario UNION ALL
    SELECT 'SK_004' AS sk_venda, 'PED_004' AS id_pedido, 'PROD_A' AS id_produto, 1 AS quantidade, CAST(2200.00 AS NUMERIC) AS preco_unitario UNION ALL
    SELECT 'SK_005' AS sk_venda, 'PED_005' AS id_pedido, 'PROD_B' AS id_produto, 2 AS quantidade, CAST(580.00 AS NUMERIC) AS preco_unitario
)

SELECT 
    v.sk_venda,
    v.id_pedido,
    p.data_pedido,
    p.id_cliente,
    COALESCE(c.nome_cliente, 'Cliente Teste') AS nome_cliente,
    COALESCE(c.estado_cliente, 'SP') AS estado_cliente,
    v.id_produto,
    p.canal_venda,
    v.quantidade,
    v.preco_unitario,
    (v.quantidade * v.preco_unitario) AS receita_bruta,
    ROUND((v.quantidade * v.preco_unitario) * {{ var('taxa_imposto') }}, 2) AS valor_imposto,
    CASE 
        WHEN (v.quantidade * v.preco_unitario) >= 2000 THEN 'Alto Valor'
        WHEN (v.quantidade * v.preco_unitario) BETWEEN 1000 AND 1999 THEN 'Médio Valor'
        ELSE 'Baixo Valor'
    END AS categoria_pedido
FROM vendas_mock v
LEFT JOIN pedidos_mock p ON v.id_pedido = p.id_pedido
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente_bk