-- =========================================================
-- Problem: Find all posts which were reacted to with a heart
-- Source : StrataScratch (contoh - ganti sesuai soal asli)
-- =========================================================

-- Query Option 1 (Menggunakan Where)
select 
    distinct
    b.post_id, 
    b.poster, 
    b.post_text, 
    b.post_keywords, 
    b.post_date from facebook_reactions as a
left join facebook_posts as b
on a.post_id = b.post_id 
where reaction like 'heart';
--Output Execution time: 0.00569 seconds

-- Query Option 2 (Advance From Claude)
select 
    * from facebook_posts as a
WHERE EXISTS (
	SELECT 1
	FROM facebook_reactions b 
	where a.post_id = b.post_id
	and b.reaction = 'heart');
-- Output Execution time: 0.00542 seconds

-- Insights
-- EXISTS adalah semi-join: berhenti begitu ketemu satu heart untuk sebuah post, jadi tidak ada duplikasi dan tidak perlu DISTINCT.
-- Perbedaan Not Exists dan Not in :
Tanpa NULL: NOT IN dan NOT EXISTS menghasilkan output yang sama.
Dengan NULL: NOT IN bisa diam-diam menghilangkan baris atau mengosongkan hasil, NOT EXISTS tetap konsisten.


