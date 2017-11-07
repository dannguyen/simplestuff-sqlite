# INNER JOIN basics

The JOIN functionality is pretty much the main event when it comes to learning SQL. It's another clause with another specific place. Everything else you've learned fits around it.

## Related reading

- [Basic SQL Inner joins](http://www.padjo.org/tutorials/database-joins/sql-inner-join/)
- [SQL Tutorial: Introduction to the SQL INNER JOIN clause](http://www.sqltutorial.org/sql-inner-join/)


## Examples with `people ` and `bios`



### How old and what gender is the person named Angela?

The `people` table does not contain basic bio info. We need to JOIN `bios` using the `id` columns in `people` and `bios` respectively. 

I intentionally split up `bios` and `peoples` so that the desired results would be obvious when figuring out `JOIN` queries.

Start off with what we already know -- how to fetch the `people` row for "Angela":


~~~sql
SELECT *
FROM 
  people
WHERE 
  name = 'Angela';
~~~

  
| id  | name   |
| --- | ------ |
| 001 | Angela |



All together:

~~~sql
SELECT *
FROM 
  people
INNER JOIN
  bios 
  ON bios.id = people.id
WHERE
  people.name = 'Angela' 
~~~





### Join all "people" and "bios"

This query is the same as above, except we leave out the `WHERE` condition. By using `SELECT *`, we are basically slapping together the columns of `people` and `bios`, side by side:


~~~sql
SELECT *
FROM 
  people
INNER JOIN
  bios; 
  ON bios.id = people.id;
~~~


|  id |   name  |  id | birthdate  | gender |
|-----|---------|-----|------------|--------|
| 001 | Angela  | 001 | 1988-02-27 | F      |
| 002 | Bill    | 002 | 1964-01-12 | M      |
| 003 | Colby   | 003 | 1955-05-08 | M      |
| 004 | Darlene | 004 | 1990-11-05 | F      |
| 005 | Elliot  | 005 | 1986-09-17 | M      |

Note something about the results: even though `bios` contains **6** rows, only **5** rows are returned. That's because there are only **5** possible rows in the `people` table to match against.

Also, note that there are two `id` columns, confusingly named the same (because they *are* named the same in their respective tables), with the same values. Using `SELECT *` when doing JOINs is almost always a bit sloppy

### Be more selective with columns

Same query concept as above, just a more verbose/explicit `SELECT` clause:


~~~sql
SELECT 
  people.id,
  people.name,
  bios.birthdate,
  bios.gender
FROM 
  people
INNER JOIN
  bios
  ON bios.id = people.id;
~~~

| id  | name    | birthdate  | gender |
| --- | ------- | ---------- | ------ |
| 001 | Angela  | 1988-02-27 | F      |
| 002 | Bill    | 1964-01-12 | M      |
| 003 | Colby   | 1955-05-08 | M      |
| 004 | Darlene | 1990-11-05 | F      |
| 005 | Elliot  | 1986-09-17 | M      |


## Examples with `people ` and `pets`


### What pets does the person named "Angela" own?

Same kind of query, using `pets` instead.

Begin by finding the 'Angela' person record:

~~~sql
SELECT *
FROM 
  people
WHERE 
  name = 'Angela';
~~~


| id  | name   |
| --- | ------ |
| 001 | Angela |


Pretend we weren't learning joins, how could we list the pets belonging to 'Angela'? We use the given `id` value found in the `people` table in a normal `WHERE` clause:


~~~sql
SELECT *
FROM 
  pets
WHERE 
  owner_id = '001';
~~~

| owner_id | name     | species | purchase_date | purchase_price |
| -------- | -------- | ------- | ------------- | -------------- |
| 001      | Einstein | dog     | 2006-10-21    | 25.0           |
| 001      | Olly     | cat     | 2012-03-12    | 15.0           |

That's the expected result. If we only cared about 'Angela', this would work fine. But in most data situations, we care more than just records associated with a singular value that can be manually queried.

### List Angela's name with her pets (hack)


One thing to notice in the above example, we still only have the "owner_id", not the owner's name. Of course, in this simple example, 'Angela' is our complete world and we don't need to list her on the table results to remind us of that. 

We don't get the luxury of a simple, singular viewpoint (i.e. *everyone is Angela!*) when doing real-world data analysis. But as an exercise, pretend it was *imperative* to list the owner's actual name, 'Angela', instead of '001' in the result set. We can still hack it:


~~~sql
SELECT 
  'Angela' AS "owner_name",
  pets.name AS "pet_name",
  species,
  purchase_date,
  purchase_price
FROM 
  pets
WHERE 
  owner_id = '001';
~~~

| owner_name | pet_name | species | purchase_date | purchase_price |
| ---------- | -------- | ------- | ------------- | -------------- |
| Angela     | Einstein | dog     | 2006-10-21    | 25.0           |
| Angela     | Olly     | cat     | 2012-03-12    | 15.0           |


### List the pets with the name of their owners

The JOIN condition needed is a little more complicated in that `pets` does not have an `id` column. This will result in an error:

~~~sql
SELECT *
FROM 
  pets
INNER JOIN
  people ON
    people.id = pets.id;
~~~

Instead, `pets` has an `owner_id` column. Just a simple name change (though a change in name is all that's needed to make data joining terrifically painful) that an be accommodated by changing the reference in the JOIN ON clause:


~~~sql
SELECT *
FROM 
  pets
INNER JOIN
  people ON
    people.id = pets.owner_id;
~~~

| owner_id | name     | species | purchase_date | purchase_price | id  | name  |
| -------- | -------- | ------- | ------------- | -------------- | --- | ------- |
| 001      | Einstein | dog     | 2006-10-21    | 25.0           | 001 | Angela  |
| 001      | Olly     | cat     | 2012-03-12    | 15.0           | 001 | Angela  |
| 005      | Flipper  | dog     | 2014-05-09    | 25.75          | 005 | Elliot  |
| 004      | Shaggy   | dog     | 1997-12-15    | 42.0           | 004 | Darlene |
| 002      | Garfield | cat     | 1990-01-03    | 20.5           | 002 | Bill    |
| 005      | Qwerty   | fish    | 2012-03-12    | 5.0            | 005 | Elliot  |
| 002      | Pounce   | cat     | 2001-04-17    | 30.0           | 002 | Bill    |
| 002      | Timba    | cat     | 2015-11-24    | 25.0           | 002 | Bill    |


By using `SELECT *`, we told the interpreter to give us all the columns of both joined tables. Which it did. It didn't cause a meaningful issue for us now, but when joined tables have the same column names, confusions and errors arise easily.


Try to stick with best practice of *not* using `SELECT *` and selecting only the columns that you need. The use of aliases can reduce confusion. More importantly, it's time to realize that columns are associated with *tables*, and when dealing with more than one table, we'll just have to identify columns with their corresponding table:


~~~sql
SELECT 
  people.id AS owner_id,
  people.name AS owner_name,
  pets.name AS pet_name,
  pets.species
FROM 
  pets
INNER JOIN
  people ON
    people.id = pets.owner_id;
~~~

| owner_id | owner_name | pet_name | species |
| -------- | ---------- | -------- | ------- |
| 001      | Angela     | Einstein | dog     |
| 001      | Angela     | Olly     | cat     |
| 005      | Elliot     | Flipper  | dog     |
| 004      | Darlene    | Shaggy   | dog     |
| 002      | Bill       | Garfield | cat     |
| 005      | Elliot     | Qwerty   | fish    |
| 002      | Bill       | Pounce   | cat     |
| 002      | Bill       | Timba    | cat     |


Why did I include/alias certain columns but not others? It all depends on the context...



## Examples with `people`, `bios`, and `pets`


### List pets.owner_id, people.name, bios.gender, pets.name, pets.species

This is a INNER JOIN between 3 tables. Syntax structure is the same order as before:


~~~sql
| owner_id | owner_name | owner_gender | pet_name | species |
| -------- | ---------- | ------------ | -------- | ------- |
| 001      | Angela     | F            | Einstein | dog     |
| 001      | Angela     | F            | Olly     | cat     |
| 005      | Elliot     | M            | Flipper  | dog     |
| 004      | Darlene    | F            | Shaggy   | dog     |
| 002      | Bill       | M            | Garfield | cat     |
| 005      | Elliot     | M            | Qwerty   | fish    |
| 002      | Bill       | M            | Pounce   | cat     |
| 002      | Bill       | M            | Timba    | cat     |
~~~


<!-- 

## Purposeful errors

Very common and sometimes catastrophic errors. Let's make them on purpose:

- Forgetting the `ON` clause
- Joining by the incorrect conditions
- Getting confused by which boolean expressions should be in `JOIN` vs. `WHERE`
- Referring to columns of a table that you aren't actually joining
 -->


<!-- 

## Purposeful mistakes

It's pretty easy to make errors in a `JOIN` clause -- it looks and acts very similar to  the `WHERE` and `HAVING` clauses. And some errors, which would seem to be syntax-related (and thus, result in an immediate error message), might still return results with silent failures.

The variety of errors might seem endless. It's easiest just to make the mistakes on purpose to see what happens.


 -->
