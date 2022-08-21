USE magist;

-- 1. How many orders are there in the dataset?
SELECT COUNT(*)
FROM orders;

-- 2. Are orders actually delivered?
SELECT order_status, COUNT(*) AS order_status_categ
FROM orders
GROUP BY order_status;


SELECT *
FROM orders
WHERE order_status = 'unavailable';


-- 3. Is Magist having user growth?
SELECT YEAR(order_purchase_timestamp) AS year_group, MONTH(order_purchase_timestamp) AS month_group, COUNT(*) AS tot 
FROM orders 
GROUP BY year_group, month_group
ORDER BY year_group, month_group;


-- 4. Which are the categories with most products?
SELECT product_category_name, COUNT(*) FROM products GROUP BY product_category_name ORDER BY COUNT(*) DESC;

SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;


SELECT COUNT(DISTINCT product_id) AS products_count
FROM products;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id;

WITH res AS (SELECT product_category_name, COUNT(*) FROM products GROUP BY product_category_name)
SELECT COUNT(*) AS total FROM res;

SELECT YEAR(order_purchase_timestamp) AS year_group, COUNT(*) AS tot FROM orders GROUP BY year_group;

WITH res AS (SELECT YEAR(order_purchase_timestamp) AS year_group, COUNT(*) AS tot FROM orders GROUP BY year_group)
SELECT SUM(res.tot) AS total FROM res;

 SELECT orders.order_id, order_items.order_id
 FROM orders
 LEFT JOIN order_items ON orders.order_id = order_items.order_id;
 
 
SELECT COUNT(*)
FROM orders;


SELECT order_items.order_id, order_items.product_id, COUNT(*)
FROM order_items
GROUP BY order_items.product_id
ORDER BY COUNT(*) DESC;

SELECT DISTINCT order_items.order_id AS distord, order_items.product_id AS distprod FROM order_items;

WITH res AS (SELECT DISTINCT order_items.order_id AS distord, order_items.product_id AS distprod FROM order_items)
SELECT COUNT(*) FROM res;
 
WITH res AS (SELECT DISTINCT order_items.order_id AS distord, order_items.product_id AS distprod FROM order_items)
SELECT orders.order_id, res.distprod
FROM orders
LEFT JOIN res ON orders.order_id = res.distord;
  
SELECT MIN(price)
FROM order_items;
 
 SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;
 

SELECT *
FROM order_items
ORDER BY price;

SELECT *
FROM order_items
WHERE price = 6735; 

SELECT COUNT(*)
FROM product_category_name_translation;


#Answers

SELECT product_category_name, COUNT(*) FROM products GROUP BY product_category_name ORDER BY COUNT(*) DESC;

WITH res AS (SELECT product_category_name, COUNT(*) FROM products GROUP BY product_category_name ORDER BY COUNT(*) DESC)
SELECT COUNT(*) FROM res;

#What categories of tech products does Magist have?
/* 'auto', 'audio', 'cds_dvds_musicals', 'air_conditioning', 'consoles_games', 'dvds_blu_ray', 'home_appliances', 'home_appliances_2', 
'electronics', 'small_appliances', 'computers_accessories', 'pc_games', 'computers', 'signaling_and_security', 'tablets-printing_image', 
'telephony', 'fixed_telephony'*/

/*'telefonia_fixa', 'telefonia', 'tablets_impressao_imagem', 'sinalizacao_e_seguranca', 'pcs', 'pc_gamer', 'informatica_acessorios', 
'eletroportateis', 'eletronicos', 'eletrodomesticos_2', 'eletrodomesticos', 'dvds_blu_ray', 'climatizacao', 'consoles_games', 'cds_dvds_musicais', 
'automotivo', 'audio'*/

SELECT o.order_id, p.product_id, oi.product_id, p.product_category_name, o.order_status, oi.price
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id;

# How many products of these tech categories have been sold?
WITH result AS (SELECT o.order_id, p.product_id, p.product_category_name, o.order_status, oi.price
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id)
SELECT r.product_category_name, r.order_status, COUNT(*)
FROM result r
WHERE r.order_status IN ('delivered', 'shipped', 'invoiced') AND r.product_category_name IN ('telefonia_fixa', 'telefonia', 'tablets_impressao_imagem', 'sinalizacao_e_seguranca', 'pcs', 'pc_gamer', 'informatica_acessorios', 
'eletroportateis', 'eletronicos', 'eletrodomesticos_2', 'eletrodomesticos', 'dvds_blu_ray', 'climatizacao', 'consoles_games', 'cds_dvds_musicais', 
'automotivo', 'audio') GROUP BY r.product_category_name, r.order_status ORDER BY r.product_category_name, r.order_status;


# What percentage does that represent from the overall number of products sold?
WITH result AS (SELECT o.order_id, p.product_id, p.product_category_name, o.order_status
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id)
SELECT COUNT(*)
FROM result r
WHERE r.order_status IN ('delivered', 'shipped', 'invoiced', 'processing');


# What’s the average price of the products being sold?
WITH result AS (SELECT o.order_id, p.product_id, p.product_category_name, o.order_status, oi.price
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id)
SELECT AVG(price)
FROM result r
WHERE r.order_status IN ('delivered', 'shipped', 'invoiced', 'processing');
 
SELECT o.order_id, p.product_id, oi.product_id, p.product_category_name, o.order_status, oi.price
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.price;