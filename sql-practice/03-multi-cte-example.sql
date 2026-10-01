-- =========================================================
-- Problem: Products Performing Above Their Category Average
-- Source : StrataScratch (contoh - ganti sesuai soal asli)
-- Topic  : Multi-CTE (Common Table Expressions)
-- =========================================================

-- Soal:
-- Tampilkan produk-produk yang penjualannya (total revenue)
-- berada DI ATAS rata-rata revenue kategori produk tersebut.

-- Skema tabel (asumsi):
-- products(product_id, product_name, category_id)
-- order_items(order_item_id, product_id, quantity, unit_price)

-- =========================================================
-- Pendekatan: pecah masalah jadi 2 langkah pakai 2 CTE
-- =========================================================

WITH product_revenue AS (
    -- CTE 1: hitung total revenue per produk
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),

category_avg AS (
    -- CTE 2: hitung rata-rata revenue per kategori,
    -- berdasarkan hasil CTE pertama (bukan tabel asli)
    SELECT
        category_id,
        AVG(total_revenue) AS avg_category_revenue
    FROM product_revenue
    GROUP BY category_id
)

-- Query utama: bandingkan tiap produk dengan rata-rata kategorinya
SELECT
    pr.product_name,
    pr.category_id,
    pr.total_revenue,
    ca.avg_category_revenue
FROM product_revenue pr
JOIN category_avg ca ON ca.category_id = pr.category_id
WHERE pr.total_revenue > ca.avg_category_revenue
ORDER BY pr.category_id, pr.total_revenue DESC;

-- =========================================================
-- Catatan / Pola yang dipelajari:
-- =========================================================
-- 1. Kenapa butuh 2 CTE, bukan 1?
--    -> CTE pertama (product_revenue) WAJIB dihitung dulu secara utuh,
--       karena CTE kedua (category_avg) butuh HASIL AGGREGATE-nya
--       (total_revenue per produk), bukan data mentah order_items.
--       Ini pola umum: "aggregate dari aggregate".
--
-- 2. CTE bisa mereferensi CTE lain yang didefinisikan sebelumnya
--    -> category_avg AS (... FROM product_revenue ...)
--       Ini yang membedakan "multi-CTE" dari sekadar 1 CTE biasa:
--       CTE kedua membangun di atas CTE pertama, seperti staging
--       layer di dbt yang membangun di atas source.
--
-- 3. Kenapa tidak pakai subquery bersarang saja?
--    -> Bisa saja secara fungsi sama persis, tapi CTE jauh lebih
--       mudah dibaca dan di-maintain saat logikanya berlapis 2+
--       tahap seperti ini. Ini juga best practice di dbt: tiap CTE
--       diberi nama yang jelas fungsinya, seperti nama model.
--
-- 4. JOIN di akhir menyatukan 2 "tabel hasil" (CTE), bukan tabel asli
--    -> product_revenue dan category_avg diperlakukan persis seperti
--       tabel biasa saat di-JOIN di query utama.
--
-- 5. Kesalahan umum pemula: taruh AVG() langsung di query utama
--    tanpa CTE terpisah.
--    -> Ini akan salah hasilnya, karena AVG() akan dihitung dari baris
--       order_items mentah (kena duplikasi tiap quantity), bukan dari
--       total_revenue per produk yang sudah di-aggregate lebih dulu.