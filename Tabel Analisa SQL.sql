-- Membuat tabel baru langsung di dalam dataset kimia_farma
CREATE OR REPLACE TABLE `kimia_farma.tabel_analisa` AS

SELECT a.transaction_id, a.date, a.branch_id, a.branch_name, a.kota, a.provinsi, a.rating_cabang, a.customer_name, 
  a.product_id, a.product_name, a.actual_price, a.discount_percentage, a.persentase_gross_laba, a.nett_sales, 
  (a.actual_price * a.persentase_gross_laba) - (a.actual_price - a.nett_sales) AS nett_profit, a.rating_transaksi

FROM (
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,
  
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  
  (p.price - (p.price * t.discount_percentage)) AS nett_sales,
  t.rating AS rating_transaksi

  FROM `kimia_farma.kf_final_transaction` t
  LEFT JOIN `kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id
  LEFT JOIN `kimia_farma.kf_product` p
    ON t.product_id = p.product_id
  ) a
