-- Membuat tabel baru langsung di dalam dataset kimia_farma
CREATE OR REPLACE TABLE `rakamin-kf-analytics-gita.kimia_farma.tabel_analisa` AS

-- Menggunakan CTE untuk merapikan penggabungan (JOIN) dan pembuatan persentase laba

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
  t.price AS actual_price,
  t.discount_percentage,

    -- Membuat tiering persentase laba berdasarkan instruksi
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  
  (t.price - (t.price * discount_percentage)) AS nett_sales,
  ((t.price - (t.price * discount_percentage))*
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
  END
  ) AS nett_profit,
  t.rating AS rating_transaksi

  FROM `rakamin-kf-analytics-gita.kimia_farma.kf_final_transaction` t
  LEFT JOIN `rakamin-kf-analytics-gita.kimia_farma.kf_kantor_cabang` c
    ON t.branch_id = c.branch_id
  LEFT JOIN `rakamin-kf-analytics-gita.kimia_farma.kf_product` p
    ON t.product_id = p.product_id


