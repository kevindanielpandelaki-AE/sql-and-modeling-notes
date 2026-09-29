-- =========================================================
-- Problem: Running Total of Monthly Revenue per Customer
-- Source : StrataScratch (contoh - ganti sesuai soal asli)
-- Topic  : Window Functions (SUM OVER, PARTITION BY, ORDER BY)
-- =========================================================

-- Soal:
-- Untuk setiap customer, tampilkan revenue per bulan beserta
-- running total (akumulasi) revenue dari bulan-bulan sebelumnya.

-- Skema tabel (asumsi):
-- orders(customer_id, order_date, revenue)

SELECT
    customer_id,
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(revenue) AS monthly_revenue,
    SUM(SUM(revenue)) OVER (
        PARTITION BY customer_id
        ORDER BY DATE_TRUNC('month', order_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
GROUP BY customer_id, DATE_TRUNC('month', order_date)
ORDER BY customer_id, order_month;

-- =========================================================
-- Catatan / Pola yang dipelajari:
-- =========================================================
-- 1. PARTITION BY customer_id
--    -> running total dihitung ULANG dari 0 untuk tiap customer,
--       bukan akumulasi lintas customer.
--
-- 2. ORDER BY di dalam OVER()
--    -> menentukan URUTAN baris yang dipakai window function,
--       beda dengan ORDER BY di akhir query yang cuma urutan
--       tampilan hasil.
--
-- 3. Kenapa SUM(SUM(revenue))?
--    -> SUM(revenue) di GROUP BY = total per bulan (aggregate biasa)
--    -> SUM(...) OVER (...) di luar = window function yang jalan
--       SETELAH aggregate, untuk mengakumulasi hasil aggregate itu.
--
-- 4. ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--    -> ini default behavior kalau pakai ORDER BY di window function,
--       tapi ditulis eksplisit di sini supaya jelas maksudnya:
--       "dari baris paling awal sampai baris sekarang".
--
-- 5. Kesalahan umum pemula: taruh window function di WHERE clause.
--    -> TIDAK BISA. Window function hanya boleh di SELECT atau ORDER BY,
--       karena dia dihitung setelah WHERE dan GROUP BY diproses.