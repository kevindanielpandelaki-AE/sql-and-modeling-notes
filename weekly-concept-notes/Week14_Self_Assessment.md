# Week 14 — Self-Assessment (Konsolidasi Fase 1)

**Periode:** 16–24 Nov 2026
**Konteks:** Review menyeluruh materi Week 1–13 (SQL, Dimensional Modeling, Git/GitHub, dbt, BigQuery, 3-Layer Architecture) sebelum transisi ke Phase 2.

## 1. Ringkasan Kompetensi yang Sudah Dikuasai

- **SQL & Fundamentals** — Query optimization, penggunaan CTE, indexing, dan EXPLAIN QUERY PLAN untuk diagnosis performa query.
- **Dimensional Modeling** — Star schema vs snowflake schema, berbagai jenis fact table, serta dimension table khusus: SCD (Slowly Changing Dimension), Conformed Dimension, Junk Dimension, Role Playing Dimension.
- **Git & GitHub** — Alur kerja lengkap: create branch, add & commit, push ke GitHub, Pull Request, merge, hingga cleaning branch. Terbiasa melakukan validasi/monitoring (git status, git log) dan tahu cara restore saat terjadi kesalahan.
- **dbt** — Memahami cara kerja dbt run/test/build, manajemen folder models (staging, intermediate, marts), fungsi dbt_project.yml dan schema.yml, penulisan model SQL, penggunaan source() dan ref(), seeds, dbt docs (generate & serve), serta konsep dan cara kerja incremental model.
- **BigQuery** — Memahami alur upload data, koneksi dbt-BigQuery secara lokal, serta validasi data di warehouse.
- **3-Layer Architecture** — Berhasil membangun arsitektur lengkap dari source → staging → intermediate → marts di project olist-dbt-project.

## 2. Bukti Konkret

- **SQL**: Seluruh model SQL dibangun menggunakan CTE, dengan source() dan ref() selalu didefinisikan di bagian paling awal query untuk konsistensi dan keterbacaan.
- **Git**: Workflow selalu diawali dengan pull (memastikan tidak ada perubahan baru di GitHub) dan git status untuk mengecek posisi repo. Setiap perubahan dikerjakan di branch terpisah, di-push ke GitHub, melalui proses PR dan merge, lalu kembali disinkronkan ke lokal lewat pull.
- **dbt**: Menetapkan disiplin arsitektur — seluruh staging model menggunakan source(), seluruh intermediate dan mart model menggunakan ref(). Ini menjaga lineage tetap bisa ditelusuri dan konsisten dengan dependency graph dbt.
- **Dimensional Modeling (grain)**: Menemukan bahwa stg_order_items memiliki grain composite (order_id + order_item_id, bukan order_item_id saja), sehingga unique test disesuaikan menggunakan dbt_utils.unique_combination_of_columns alih-alih unique test biasa.
- **Dimensional Modeling (YAGNI)**: Memutuskan untuk TIDAK membuat dim_customers dan dim_sellers karena belum ada use case analitik yang konkret — menghindari over-engineering/speculative design.
- **3-Layer Architecture**: Memutuskan untuk skip pembuatan int_products_translated sebagai intermediate model terpisah, karena join antara stg_products dan stg_product_category_translation tidak mengubah grain — join dilakukan langsung di layer mart (dim_products).
- **dbt Testing**: Mengimplementasikan source freshness dengan warn_after 90 hari dan error_after 180 hari, dengan catatan bahwa dataset Olist bersifat statis (tidak ada data baru masuk), sehingga freshness check ini pada akhirnya akan selalu error — sebuah kesadaran bahwa tool freshness perlu disesuaikan konteksnya dengan sifat dataset, bukan dipasang tanpa pertimbangan.

## 3. Gap yang Teridentifikasi

- **git rebase** dan **git bisect** belum pernah masuk materi Week 1–13. Keduanya sudah dipelajari dan dipraktikkan langsung minggu ini (termasuk mencoba git bisect di repo pribadi). Kesimpulan: git bisect saat ini kurang relevan untuk workflow solo yang bersifat "menambah file baru" (bukan kasus regresi), tapi relevansinya akan muncul di Phase 2 saat pipeline dbt sudah lebih kompleks dan berpotensi mengalami regresi data.

## 4. Refleksi Proses Belajar

Alur proses pembuatan pipeline end-to-end (dari source hingga mart, termasuk otomasi test dan dokumentasi) sudah dipahami dan terasa terbiasa. Area yang masih perlu improvement: detail penulisan SQL dan YAML tertentu kadang masih perlu melihat referensi, menandakan pemahaman konsep sudah kuat namun fluency penulisan kode masih berkembang — wajar untuk tahap fundamentals dan akan terasah lewat intensitas project di Phase 2.

## 5. Kesiapan untuk Phase 2

Dengan pemahaman Analytics Engineering yang dimiliki saat ini — mencakup pemahaman konsep (bukan sekadar hafalan sintaks) yang terbukti dari kemampuan menjawab skenario kasus nyata terkait project Olist sendiri — dinilai cukup siap untuk memasuki Phase 2: periode intensif pembangunan project dbt, eksplorasi BigQuery lebih dalam, dan pengembangan portfolio.
