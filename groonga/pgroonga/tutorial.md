# Tutorial

I will learn the following tutorial and write what I learned.
- ref: https://pgroonga.github.io/ja/tutorial/

## Full text search
```sql
EXPLAIN SELECT * FROM memos WHERE content &@'全文検索';
  Index Scan using pgronnga_content_index on memos (cost=0.00..43.18 rows=1 width=36)
    Index Cond: (content &@ '全文検索'::text)
(2 rows)
```

```sql
EXPLAIN SELECT * FROM memos WHERE content &@~ 'PGroonga OR PostgreSQL';
 Bitmap Heap Scan on memos  (cost=0.00..20.41 rows=1 width=36)
   Recheck Cond: (content &@~ 'PGronnga OR PostgreSQL'::text)
   ->  Bitmap Index Scan on pgronnga_content_index  (cost=0.00..0.00 rows=13 width=0)
         Index Cond: (content &@~ 'PGronnga OR PostgreSQL'::text)
(4 rows)
```

```sql
EXPLAIN SELECT * FROM memos WHERE content LIKE '%全文検
索%';
 Bitmap Heap Scan on memos  (cost=0.00..13.98 rows=1 width=36)
   Recheck Cond: (content ~~ '%全文検索%'::text)
   ->  Bitmap Index Scan on pgronnga_content_index  (cost=0.00..0.00 rows=318 width=0)
         Index Cond: (content ~~ '%全文検索%'::text)
(4 rows)
```

```sql
EXPLAIN SELECT *, pgroonga_score(tableoid, ctid) AS score
  FROM score_memos
  WHERE content &@ 'PGroonga' OR content &@ 'PostgreSQL'
  ORDER BY pgroonga_score(tableoid, ctid) DESC;

 Sort  (cost=508.33..508.34 rows=3 width=44)
   Sort Key: (pgroonga_score(tableoid, ctid)) DESC
   ->  Bitmap Heap Scan on score_memos  (cost=0.00..508.31 rows=3 width=44)
         Recheck Cond: ((content &@ 'PGroonga'::text) OR (content &@ 'PostgreSQL'::text))
         ->  BitmapOr  (cost=0.00..0.00 rows=330 width=0)
               ->  Bitmap Index Scan on pgroonga_score_memos_content_index  (cost=0.00..0.00 rows=318 width=0)
                     Index Cond: (content &@ 'PGroonga'::text)
               ->  Bitmap Index Scan on pgroonga_score_memos_content_index  (cost=0.00..0.00 rows=13 width=0)
                     Index Cond: (content &@ 'PostgreSQL'::text)
(9 rows)
```

```sql
EXPLAIN SELECT *, pgroonga_score(tableoid, ctid) AS score              
  FROM score_memos
  WHERE content &@~ 'PGroonga OR PostgreSQL'
  ORDER BY pgroonga_score(tableoid, ctid) DESC;

 Sort  (cost=20.43..20.43 rows=1 width=44)
   Sort Key: (pgroonga_score(tableoid, ctid)) DESC
   ->  Bitmap Heap Scan on score_memos  (cost=0.00..20.42 rows=1 width=44)
         Recheck Cond: (content &@~ 'PGroonga OR PostgreSQL'::text)
         ->  Bitmap Index Scan on pgroonga_score_memos_content_index  (cost=0.00..0.00 rows=13 width=0)
               Index Cond: (content &@~ 'PGroonga OR PostgreSQL'::text)
(6 rows)
```EXPLAIN SELECT pgroonga_highlight_html (content, pgroonga_query_extract_keywords ('PostgreSQL database')) AS highlighted_content 
FROM sample_texts
WHERE CONTENT &@~ 'PostgreSQL database';

```sql
EXPLAIN SELECT pgroonga_highlight_html (content, pgroonga_query_extract_keywords ('PostgreSQL database')) AS highlighted_content 
  FROM sample_texts
  WHERE CONTENT &@~ 'PostgreSQL database';

 Index Scan using pgroonga_sample_content_index on sample_texts  (cost=0.00..43.18 rows=1 width=32)
   Index Cond: (content &@~ 'PostgreSQL database'::text)
(2 rows)
```


### Synonyms

```sql
EXPLAIN SELECT name AS synonym_names
  FROM names
  WHERE name &@~ pgroonga_query_expand(
    'synonym_groups', 'synonyms', 'synonyms','斉藤' ::varchar;

 Bitmap Heap Scan on public.names  (cost=0.00..29.06 rows=1 width=516) (actual time=0.975..0.976 rows=3 loops=1)
   Output: name
   Recheck Cond: (names.name &@~ (pgroonga_query_expand('synonym_groups'::cstring, 'synonyms'::text, 'synonyms'::text, '斉藤'::text))::character varying)
   Heap Blocks: exact=1
   ->  Bitmap Index Scan on pgroonga_names_index  (cost=0.00..0.00 rows=25 width=0) (actual time=0.969..0.969 rows=3 loops=1)
         Index Cond: (names.name &@~ (pgroonga_query_expand('synonym_groups'::cstring, 'synonyms'::text, 'synonyms'::text, '斉藤'::text))::character varying)
 Planning Time: 4.411 ms
 Execution Time: 1.094 ms
(8 rows)
```

```sql
EXPLAIN ANALYZE VERBOSE
  SELECT name AS synonym_names
  FROM names
  WHERE name &@~ pgroonga_query_expand(
    'synonym_groups', 'synonyms', 'synonyms','斉藤');

 Seq Scan on public.names  (cost=0.00..124.38 rows=1 width=516) (actual time=0.816..3.095 rows=3 loops=1)
   Output: name
   Filter: ((names.name)::text &@~ pgroonga_query_expand('synonym_groups'::cstring, 'synonyms'::text, 'synonyms'::text, '斉藤'::text))
   Rows Removed by Filter: 3
 Planning Time: 0.107 ms
 Execution Time: 3.130 ms
```