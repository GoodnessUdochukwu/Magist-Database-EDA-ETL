USE magist;

# What categories of tech products does Magist have?
/* 'auto', 'audio', 'cds_dvds_musicals', 'air_conditioning', 'consoles_games', 'dvds_blu_ray', 'home_appliances', 'home_appliances_2', 
'electronics', 'small_appliances', 'computers_accessories', 'pc_games', 'computers', 'signaling_and_security', 'tablets-printing_image', 
'telephony', 'fixed_telephony'*/

/*'telefonia_fixa', 'telefonia', 'tablets_impressao_imagem', 'sinalizacao_e_seguranca', 'pcs', 'pc_gamer', 'informatica_acessorios', 
'eletroportateis', 'eletronicos', 'eletrodomesticos_2', 'eletrodomesticos', 'dvds_blu_ray', 'climatizacao', 'consoles_games', 'cds_dvds_musicais', 
'automotivo', 'audio'*/

# How many products of these tech categories have been sold? 
# What percentage does that represent from the overall number of products sold?

SELECT COUNT(*) AS total_tech_sold
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios');

SELECT YEAR(order_purchase_timestamp), COUNT(*) AS total_tech_sold
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios')
GROUP BY YEAR(order_purchase_timestamp) 
ORDER BY YEAR(order_purchase_timestamp) ASC;

SELECT p.product_category_name, COUNT(*) AS total_tech_categ_sold
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios') 
GROUP BY p.product_category_name 
ORDER BY p.product_category_name;

SELECT p.product_category_name, YEAR(order_purchase_timestamp), COUNT(*) AS total_tech_categ_sold
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios') 
GROUP BY p.product_category_name, YEAR(order_purchase_timestamp) 
ORDER BY p.product_category_name, YEAR(order_purchase_timestamp) ASC;

SELECT COUNT(*)
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered');


# What’s the average price of the products being sold?
SELECT AVG(price) 
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered');
# 120.22222749127509 

SELECT YEAR(order_purchase_timestamp), AVG(price) 
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered')
GROUP BY YEAR(order_purchase_timestamp) 
ORDER BY YEAR(order_purchase_timestamp) ASC;

SELECT YEAR(order_purchase_timestamp), AVG(price) AS tech_ave_price
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios')
GROUP BY YEAR(order_purchase_timestamp) 
ORDER BY YEAR(order_purchase_timestamp) ASC;

SELECT p.product_category_name, YEAR(order_purchase_timestamp), AVG(price) AS tech_categ_ave_price
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios')
GROUP BY p.product_category_name, YEAR(order_purchase_timestamp) 
ORDER BY p.product_category_name, YEAR(order_purchase_timestamp) ASC;

SELECT MAX(price) 
FROM order_items oi;

SELECT MIN(price) 
FROM order_items oi;

# Are expensive tech products popular? ANSWER: Find ratio of total number of sold expensive tech products to total number of sold tech products
SELECT COUNT(*) AS total
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios') AND oi.price > 150;
# 1839 expensive tech products

# How many sellers are there?
SELECT COUNT(*)
FROM sellers;

# What’s the average monthly revenue of Magist’s sellers?
WITH res AS (SELECT YEAR(order_purchase_timestamp) AS yr, MONTH(order_purchase_timestamp), SUM(oi.price) AS total
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered')
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp))
SELECT yr, AVG(total)
FROM res 
GROUP BY yr
ORDER BY yr ASC;

WITH res AS (SELECT YEAR(order_purchase_timestamp) AS yr, MONTH(order_purchase_timestamp), SUM(oi.price) AS total
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios')
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp))
SELECT yr, AVG(total)
FROM res 
GROUP BY yr
ORDER BY yr ASC;

SELECT YEAR(order_purchase_timestamp) AS yr, SUM(oi.price) AS total_tech_revenue
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios')
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp);

SELECT SUM(oi.price) AS total_tech_revenue
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered') AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios');

SELECT YEAR(order_purchase_timestamp), SUM(oi.price) AS total_prdt_revenue
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered')
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp);

SELECT SUM(oi.price) AS total_prdt_revenue
FROM orders o
RIGHT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('delivered');


# What’s the average time between the order being placed and the product being delivered?
#Time between order timestamp and customer reception date
# Total number of deliveries
SELECT COUNT(*)
FROM orders o
WHERE o.order_status = 'delivered';

# average delivery time
WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT AVG(datediff) FROM res;

# How many orders are delivered on time vs orders delivered with a delay?
WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT COUNT(*) AS delay FROM res WHERE datediff < 0;

WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT AVG(datediff) * -1 AS ave_delay_time FROM res WHERE datediff < 0;

WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT COUNT(*) AS on_time FROM res WHERE res.datediff >= 0;

WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT AVG(datediff) * -1 AS ave_ontime_time FROM res WHERE datediff >= 0;

# Is there any pattern for delayed orders, e.g. big products being delayed more often?
# Count of all the delivered but delayed products
WITH res AS (SELECT *, TIMESTAMPDIFF(DAY, o.order_delivered_customer_date, o.order_estimated_delivery_date) AS datediff
FROM orders o
WHERE o.order_status = 'delivered')
SELECT COUNT(DISTINCT oi.product_id)
FROM order_items oi
LEFT JOIN res ON oi.order_id = res.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE res.datediff < 0 AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios');
#ORDER BY p.product_weight_g DESC; AND p.product_category_name IN ('eletronicos', 'pcs', 'sinalizacao_e_seguranca', 'tablets_impressao_imagem', 'informatica_acessorios') AND oi.price > 150
#AND p.product_weight_g < 2460.7179



