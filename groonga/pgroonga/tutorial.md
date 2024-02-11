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
```

