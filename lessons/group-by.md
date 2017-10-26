# Aggregation with GROUP BY


## Related reading

- [Grouping in SQL](http://2014.padjo.org/tutorials/databases/sql-group/)
- [Aggregate functions in SQL](http://2014.padjo.org/tutorials/databases/sql-aggregate-functions/)



## Examples


### Count by gender in "bios"

~~~sql
SELECT
  gender,
  COUNT(*)
FROM 
  bios
GROUP BY gender;
~~~

| gender | COUNT(*) |
| ------ | -------- |
| F      | 3        |
| M      | 3        |


### Count species in "pets", sort by least common in count


~~~sql
SELECT
  species,
  COUNT(*) AS ct
FROM 
  pets
GROUP BY 
  species
ORDER BY
  ct ASC;
~~~

| species | ct |
| ------- | -- |
| fish    | 1  |
| dog     | 3  |
| cat     | 4  |



### Find the average, max, and min of cat purchase prices

Note the lack of a `GROUP BY` clause since we are only selecting for one kind of category, i.e. `species='cat'`:


~~~sql
SELECT
  MIN(purchase_price),
  MAX(purchase_price),
  AVG(purchase_price)
FROM 
  pets
WHERE 
  species = 'cat';
~~~

| MIN(purchase_price) | MAX(purchase_price) | AVG(purchase_price) |
| ------------------- | ------------------- | ------------------- |
| 15.0                | 30.0                | 22.625              |



#### Add aliases to the cat prices

The formulas in the column headers is visually cumbersome (and can cause issues in more complex queries). Let's give them more human-friendly aliases:



~~~sql
SELECT
  MIN(purchase_price) AS low_price,
  MAX(purchase_price) AS high_price,
  AVG(purchase_price) AS avg_price
FROM 
  pets
WHERE 
  species = 'cat';
~~~

| low_price | high_price | avg_price |
| --------- | ---------- | --------- |
| 15.0      | 30.0       | 22.625    |



### List the pricing for every pet species

This is where we need the `GROUP BY` clause, and to include the `species` column in the output. 

If you are copy-pasting from the previous examples, remember to remove the `WHERE` condition:



~~~sql
SELECT
  species,
  MIN(purchase_price) AS low_price,
  MAX(purchase_price) AS high_price,
  AVG(purchase_price) AS avg_price
FROM 
  pets
GROUP BY
  species;
~~~

| species | low_price | high_price | avg_price        |
| ------- | --------- | ---------- | ---------------- |
| cat     | 15.0      | 30.0       | 22.625           |
| dog     | 25.0      | 42.0       | 30.9166666666667 |
| fish    | 5.0       | 5.0        | 5.0              |


### List the owner_id of the owner who owns the most pets of a single kind

Kind of a nonsensical query, but it's not necessarily the case that the person who owns the most pet of one type (e.g. 3 cats) also owns the most pets overall.


~~~sql
SELECT 
  owner_id,
  species,
  COUNT(*) AS petcount
FROM pets
GROUP BY owner_id, species
ORDER BY petcount DESC;
~~~

| owner_id | species | petcount |
| -------- | ------- | -------- |
| 002      | cat     | 3        |
| 001      | cat     | 1        |
| 001      | dog     | 1        |
| 004      | dog     | 1        |
| 005      | dog     | 1        |
| 005      | fish    | 1        |


## Troubleshooting


### Leaving out a grouping field

One of the most common type of `GROUP BY` errors is leaving out a field in the `GROUP BY` clause.

Using the previous query but only grouping by `owner_id` (and not along with `species`), we get a very different answer:


~~~sql
SELECT 
  owner_id,
  species,
  COUNT(*) AS petcount
FROM pets
GROUP BY 
  owner_id
ORDER BY 
  petcount DESC;
~~~

| owner_id | species | petcount |
| -------- | ------- | -------- |
| 002      | cat     | 3        |
| 001      | cat     | 2        |
| 005      | fish    | 2        |
| 004      | dog     | 1        |


Perhaps the most dangerous aspect of this error -- an error from the user, not the SQL interpreter mind you -- is how the *structure of the result* looks like what we expect, even though the answer is much different: The owner `002` is listed as having 3 cats, when in reality, it is owner `003`.


Try including `species` in the grouping, and leaving out `owner_id`:


~~~sql
SELECT 
  owner_id,
  species,
  COUNT(*) AS petcount
FROM pets
GROUP BY 
  species
ORDER BY 
  petcount DESC;
~~~

Again, wrong -- and inexplicably wrong --answer:

| owner_id | species | petcount |
| -------- | ------- | -------- |
| 002      | cat     | 4        |
| 004      | dog     | 3        |
| 005      | fish    | 1        |



The result isn't *quite* random, but for the intents and purposes of sane data analysis, it's best to assume that the aggregated/grouped values are random and thus just *wrong*.

Sometimes, you can get the correct answer even by messing up `GROUP BY`. That is by far the worst kind of error, when you get the right answer (in one instance) out of pure luck.


### SELECT only the fields that you GROUP BY

This error is related to the funky results you get when you accidentally leave out a grouping field. As we just saw, leaving out `owner_id` in `GROUP BY` didn't leave out `owner_id` *as a column*, which is why the result set didn't seem wrong.

The best practice is to only select columns for the result set that you plan to `GROUP BY`. This does **not** include the aggregate value columns, as those actually mean something when doing a `GROUP BY`.

This query is **good**, even if nonsensical:


~~~sql
SELECT 
  species
FROM 
  pets
GROUP BY 
  species;
~~~

| species |
| ------- |
| cat     |
| dog     |
| fish    |

This query is **totally fine** -- all other columns than "species" in the result are aggregate values:


~~~sql
SELECT 
  species,
  COUNT(*) AS num,
  SUM(purchase_price) AS totalprice
FROM 
  pets
GROUP BY 
  species;
~~~

| species | num | totalprice |
| ------- | --- | ---------- |
| cat     | 4   | 90.5       |
| dog     | 3   | 92.75      |
| fish    | 1   | 5.0        |


----------------

This query is **bad. Just bad**:

~~~sql
SELECT 
  species,
  purchase_price
FROM 
  pets
GROUP BY 
  species;
~~~

To which dog does the `42.0` price belong to? It doesn't make sense.

| species | purchase_price |
| ------- | -------------- |
| cat     | 25.0           |
| dog     | 42.0           |
| fish    | 5.0            |


And this query is even worse, even though the answers seem technically right:


~~~sql
SELECT 
  name,
  species,
  MAX(purchase_price)
FROM 
  pets
GROUP BY 
  species;
~~~

| name   | species | MAX(purchase_price) |
| ------ | ------- | ------------------- |
| Pounce | cat     | 30.0                |
| Shaggy | dog     | 42.0                |
| Qwerty | fish    | 5.0                 |

The named pets are indeed the most expensive of their species. So it seems like we got an answer to the question: "Which pet is the most expensive by species"?

However, though it might be a feature of SQLite to correctly link the non-grouped by field (`name`) to the proper record, it's not behavior to depend upon. And in other SQL variants, such as PostgreSQL, it will throw an error.

So how to get around this? It can be a little complicated, and will often require a subquery and/or a JOIN. This is outside of the scope of this lesson, but just for curiosity's sake:



~~~sql
SELECT 
  pets.name, 
  pets.species,
  pets.purchase_price
FROM pets
INNER JOIN 
    (SELECT 
      species, MAX(purchase_price) AS max_price
    FROM pets
    GROUP BY species)
  AS maxes
  ON maxes.species = pets.species
     AND maxes.max_price = pets.purchase_price;
~~~

Admittedly, that was one very-long query to get pretty much the same answer. It's not as important to decipher the above query, as much as it is to understand how important it is to follow the rule of selecting and grouping by the same columns.


| name   | species | purchase_price |
| ------ | ------- | -------------- |
| Shaggy | dog     | 42.0           |
| Qwerty | fish    | 5.0            |
| Pounce | cat     | 30.0           |














