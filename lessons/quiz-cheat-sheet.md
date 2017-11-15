# SQL Cheat Sheet

A standard SELECT query that picks (and aliases) a couple columns, filters the records with a couple of conditions, sorts by a couple of fields, and limits the result set to the first 5 results. 

```sql
SELECT
  column_a AS cola, 
  column_b AS colby
FROM
  table
WHERE 
  cola > colby
ORDER BY
  cola ASC,
  colby DESC
LIMIT 5;
```


Summarization of the entire set

```sql
SELECT
  SUM(column_a) AS sum_a,
  AVG(column_b) AS avg_b,
  COUNT(*) as the_count
FROM
  table;
```

GROUP BY summarization

```sql
SELECT
  a, b
FROM
  table
GROUP BY a;
```


GROUP BY summarization




INNER JOIN

```sql
SELECT 
  stuff.id,
  things.name
FROM
  stuff
INNER JOIN
  things ON
``  things.id = stuff.id
WHERE
  1 = 1;
```



------------

What's wrong?


```sql
SELECT 
  GROUP(val)
FROM n;
```

```sql
SELECT 
  x, y
FROM n
INNER JOIN pets;
```


