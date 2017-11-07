# LEFT JOIN Basics

The syntax for LEFT JOINs is the same as for INNER JOINs. It is the results that are different. 

Related reading:

- [PADJO tutorial: SQL Left Joins](http://www.padjo.org/tutorials/database-joins/sql-left-joins/)
- [PADJO tutorial: NULL in databases](http://www.padjo.org/tutorials/databases/sql-null/)
- [PADJO 2015 tutorial: Using LEFT JOINs to find what's missing from one table to another](http://2015.padjo.org/tutorials/babynames-and-college-salaries/035-left-joins-and-join-practice/)
- [Stack Overflow: What is the difference between “INNER JOIN” and “OUTER JOIN”?](https://stackoverflow.com/questions/38549/what-is-the-difference-between-inner-join-and-outer-join)


## LEFT vs INNER JOIN

As we learned in [INNER JOIN basics](../lessons/inner-join-agg.md), an `INNER JOIN` returns rows from tables when the `ON` condition is **true**:

~~~sql
SELECT *
FROM 
  bios
INNER JOIN
  people
  ON bios.id = people.id;
~~~


|  id |   name  |  id | birthdate  | gender |
|-----|---------|-----|------------|--------|
| 001 | Angela  | 001 | 1988-02-27 | F      |
| 002 | Bill    | 002 | 1964-01-12 | M      |
| 003 | Colby   | 003 | 1955-05-08 | M      |
| 004 | Darlene | 004 | 1990-11-05 | F      |
| 005 | Elliot  | 005 | 1986-09-17 | M      |


However, if you look at the `bios` table, you'll see that there's at least one row in which the condition `bios.id = people.id` is not satisfied, because this particular row in `bios` has no corresponding match in `people` (happens with sloppy data entry, or data syncing):

| id  | birthdate  | gender |
| --- | ---------- | ------ |
| 001 | 1988-02-27 | F      |
| 002 | 1964-01-12 | M      |
| 003 | 1955-05-08 | M      |
| 004 | 1990-11-05 | F      |
| 005 | 1986-09-17 | M      |
| 424 | 1991-07-23 | F      |

 A `LEFT JOIN` returns all rows in the "leftmost" table -- in the previous query, `bios` -- regardless if each row satisfies the `ON` clause:


~~~sql
SELECT *
FROM 
  bios
LEFT JOIN
  people
  ON bios.id = people.id;
~~~

The very last row of `bios` is included, but its corresponding match in `people` are `NULL` columns (i.e. `people.id` and `people.name`):

|  id | birthdate  | gender |  id  |   name  |
|-----|------------|--------|------|---------|
| 001 | 1988-02-27 | F      | 001  | Angela  |
| 002 | 1964-01-12 | M      | 002  | Bill    |
| 003 | 1955-05-08 | M      | 003  | Colby   |
| 004 | 1990-11-05 | F      | 004  | Darlene |
| 005 | 1986-09-17 | M      | 005  | Elliot  |
| 424 | 1991-07-23 | F      | NULL | NULL    |

Why would we ever want to do this? Perhaps we want to ask:

> Which rows in `bios` have no match in `people`?


~~~sql
SELECT *
FROM 
  bios
LEFT JOIN
  people
  ON bios.id = people.id
WHERE
  people.id IS NULL;
~~~

|  id | birthdate  | gender |  id  | name |
|-----|------------|--------|------|------|
| 424 | 1991-07-23 | F      | NULL | NULL |


### What does "left" table mean?

The "left" table can be thought of as the table name that comes first in the query. In a standard `SELECT...FROM...JOIN` query, this would be the table name that is in the `FROM` clause. Here, `bios` is the "left" table:

~~~sql
SELECT *
FROM 
  bios
LEFT JOIN
  people
  ON bios.id = people.id
  ...
  ...;
~~~

Notice if we switch the references, so that `people` is the "left" table, the LEFT JOIN doesn't return any rows with NULL values. Because there are no `people` rows that are "left out" of the JOIN:


~~~sql
SELECT *
FROM 
  people
LEFT JOIN
  bios
  ON bios.id = people.id;
~~~

|  id |   name  |  id | birthdate  | gender |
|-----|---------|-----|------------|--------|
| 001 | Angela  | 001 | 1988-02-27 | F      |
| 002 | Bill    | 002 | 1964-01-12 | M      |
| 003 | Colby   | 003 | 1955-05-08 | M      |
| 004 | Darlene | 004 | 1990-11-05 | F      |
| 005 | Elliot  | 005 | 1986-09-17 | M      |


To hammer in the concept, try an INNER JOIN with a nonsensical `ON` condition that is *guaranteed* to have no rows for which it is **true**:


~~~sql
SELECT *
FROM 
  people
INNER JOIN
  bios
    ON bios.birthdate = people.name;
~~~

For an `INNER JOIN`, you should get **0** results.

Now, try a `LEFT JOIN`:



~~~sql
SELECT *
FROM 
  people
LEFT JOIN
  bios
    ON bios.birthdate = people.name;
~~~

|  id |   name  |  id  | birthdate | gender |
|-----|---------|------|-----------|--------|
| 001 | Angela  | NULL | NULL      | NULL   |
| 002 | Bill    | NULL | NULL      | NULL   |
| 003 | Colby   | NULL | NULL      | NULL   |
| 004 | Darlene | NULL | NULL      | NULL   |
| 005 | Elliot  | NULL | NULL      | NULL   |


## Examples

The logic can be kind of abstract, so it's often easier to understand `LEFT JOIN` with examples of the kinds of "real" questions we'd want to ask.


### All "bios" records that don't have a person

We already did this example, but here it is again, a little more refined:


~~~sql
SELECT
  bios.*
FROM 
  bios
LEFT JOIN
  people
  ON 
    people.id = bios.id
WHERE 
  people.id IS NULL;
~~~

| id  | birthdate  | gender |
| --- | ---------- | ------ |
| 424 | 1991-07-23 | F      |


### The ids and names of all people who do not own pets

Think to yourself how you would get a list of people ids and names for `people` records that could be joined with `pets`:


~~~sql
SELECT
  people.id,
  people.name
FROM 
  people
INNER JOIN
  pets ON
    people.id = pets.owner_id;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 001 | Angela  |
| 002 | Bill    |
| 002 | Bill    |
| 002 | Bill    |
| 004 | Darlene |
| 005 | Elliot  |
| 005 | Elliot  |


You might want to use a `GROUP BY` to reduce the redundancy, i.e. the clutter, i.e. just show unique values:


~~~sql
SELECT 
  people.id,
  people.name
FROM 
  people
INNER JOIN
  pets ON
    people.id = pets.owner_id
GROUP BY 
  people.id, people.name;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 002 | Bill    |
| 004 | Darlene |
| 005 | Elliot  |

Clearly, we're missing *somebody*. This is where `LEFT JOIN` comes in:



~~~sql
SELECT 
  people.id,
  people.name
FROM 
  people
LEFT JOIN
  pets ON
    people.id = pets.owner_id;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 001 | Angela  |
| 002 | Bill    |
| 002 | Bill    |
| 002 | Bill    |
| 003 | Colby   |
| 004 | Darlene |
| 005 | Elliot  |
| 005 | Elliot  |


Use the `WHERE` clause to filter the results to show only the `people` rows in which the corresponding `pets` columns are `NULL`. No need to use `GROUP BY` (when you think it out, logically):


~~~sql
SELECT 
  people.id,
  people.name
FROM 
  people
LEFT JOIN
  pets ON
    people.id = pets.owner_id
WHERE
  pets.owner_id IS NULL;
~~~

| id  | name  |
| --- | ----- |
| 003 | Colby |
