-- Query 1 Membuat tabel analisa dengan join transaction, kantor cabang, dan product
CREATE OR REPLACE TABLE `rakamin-kimiafarmaa.kimia_farma.kf_analysis_table` AS SELECT
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
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  ROUND(t.price * (1 - t.discount_percentage), 2) AS nett_sales, t.rating AS rating_transaksi
FROM `rakamin-kimiafarmaa.kimia_farma.kf_final_transaction` t

LEFT JOIN `rakamin-kimiafarmaa.kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id
LEFT JOIN `rakamin-kimiafarmaa.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;

-- Query 2 Menambahkan kolom nett_profit
CREATE OR REPLACE TABLE `rakamin-kimiafarmaa.kimia_farma.kf_analysis_table` AS
SELECT
  *,
  ROUND(nett_sales * persentase_gross_laba, 2) AS nett_profit
FROM `rakamin-kimiafarmaa.kimia_farma.kf_analysis_table`;
