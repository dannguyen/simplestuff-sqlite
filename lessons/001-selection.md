# The SELECT clause



## Selecting arbitrary values and columns without a table


~~~sql
SELECT 'hello';
~~~

| 'hello' |
| ------- |
| hello   |




~~~sql
SELECT 42;
~~~

| 42 |
| -- |
| 42 |


We can also do mathematical expressions:


~~~sql
SELECT 1 * 2 * (3 + 100);
~~~

| 1 * 2 * (3 + 100) |
| ----------------- |
| 206               |


## Using commas as a delimiter for multiple columns


~~~sql
SELECT 
  1, 2, 3;
~~~

| 1 | 2 | 3 |
| - | - | - |
| 1 | 2 | 3 |



~~~sql
SELECT 
  'hello', 
  'world';
~~~

| 'hello' | 'world' |
| ------- | ------- |
| hello   | world   |



## Selecting FROM a table


~~~sql
SELECT 
  id, name
FROM people;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 002 | Bill    |
| 003 | Carla   |
| 004 | Darlene |
| 005 | Elliot  |


We can reverse the order of the column layout:


~~~sql
SELECT 
  name, id
FROM 
  people;
~~~

| name    | id  |
| ------- | --- |
| Angela  | 001 |
| Bill    | 002 |
| Carla   | 003 |
| Darlene | 004 |
| Elliot  | 005 |


We can select just one column:



~~~sql
SELECT
  name
FROM 
  people;
~~~

| name    |
| ------- |
| Angela  |
| Bill    |
| Carla   |
| Darlene |
| Elliot  |

We can select duplicates of columns:


~~~sql
SELECT
  id, name, name,
  id, id, name
FROM 
  people;
~~~


|  id |   name  |   name  |  id |  id |   name  |
|-----|---------|---------|-----|-----|---------|
| 001 | Angela  | Angela  | 001 | 001 | Angela  |
| 002 | Bill    | Bill    | 002 | 002 | Bill    |
| 003 | Carla   | Carla   | 003 | 003 | Carla   |
| 004 | Darlene | Darlene | 004 | 004 | Darlene |
| 005 | Elliot  | Elliot  | 005 | 005 | Elliot  |


And we can mix columns and literal values



~~~sql
SELECT 
  id, 42, 
  'hello', name
FROM 
  people;
~~~

| id  | 42 | 'hello' | name    |
| --- | -- | ------- | ------- |
| 001 | 42 | hello   | Angela  |
| 002 | 42 | hello   | Bill    |
| 003 | 42 | hello   | Carla   |
| 004 | 42 | hello   | Darlene |
| 005 | 42 | hello   | Elliot  |




And we can select no columns at all:



~~~sql
SELECT
  1,2,3
FROM 
  people;
~~~

| 1 | 2 | 3 |
| - | - | - |
| 1 | 2 | 3 |
| 1 | 2 | 3 |
| 1 | 2 | 3 |
| 1 | 2 | 3 |
| 1 | 2 | 3 |


Note that the number of rows in the result is the exact number of rows in `people`. 

The query retrieves every row from `people` all the same, it's just that we've decided to *select* nothing of use from the actual data. The SQL interpreter has no qualms about doing useless work for us -- which is very important to keep in mind as it also means the interpreter will never protect us from our own accidental carelessness or stupidity. 


## Best practices and considerations

### Avoid using the star; be explicit about what you want

It's hard to break out of the habit of using the `*` operator to call in all the columns of a table. It's the easiest thing to type, and we are somewhat inclined to want all the data that we can get by default:


~~~sql
SELECT *
FROM pets;
~~~

| name     | species | purchase_date | price | owner_id |
| -------- | ------- | ------------- | ----- | -------- |
| Einstein | dog     | 2006-10-21    | 25.0  | 001      |
| Olly     | cat     | 2012-03-12    | 15.0  | 001      |
| Flipper  | dog     | 2014-05-09    | NULL  | 005      |
| Shaggy   | dog     | 1997-12-15    | 42.0  | 004      |
| Garfield | cat     | 1990-01-03    | 20.5  | 002      |
| Qwerty   | fish    | 2012-03-12    | 5.0   | 005      |
| Pounce   | cat     | 2001-04-17    | 30.0  | 002      |
| Timba    | cat     | 2015-11-24    | 25.0  | 002      |


But you should avoid it whenever possible, especially when working on a problem that requires taking some time to think-out and fine-tune the query. Most real-world databases contain many more columns than you need to actually retrieve and see. But even if you do need all the columns, just write it out. There's no rush when it comes to SQL.


~~~sql
SELECT
  name,
  species,
  purchase_date,
  price,
  owner_id
FROM
  pets;
~~~

More often than not, you'll realize that you'll want the columns in a different order than what's specified in the table schema. If you started out by writing the lazy `SELECT *`, you'd convince yourself to move on. But if you took the time to write things out, you'll know that switching up the columns is nothing:


~~~sql
SELECT
  species,
  name,
  price,
  purchase_date,
  owner_id
FROM
  pets;
~~~

| species | name     | price | purchase_date | owner_id |
| ------- | -------- | ----- | ------------- | -------- |
| dog     | Einstein | 25.0  | 2006-10-21    | 001      |
| cat     | Olly     | 15.0  | 2012-03-12    | 001      |
| dog     | Flipper  | NULL  | 2014-05-09    | 005      |
| dog     | Shaggy   | 42.0  | 1997-12-15    | 004      |
| cat     | Garfield | 20.5  | 1990-01-03    | 002      |
| fish    | Qwerty   | 5.0   | 2012-03-12    | 005      |
| cat     | Pounce   | 30.0  | 2001-04-17    | 002      |
| cat     | Timba    | 25.0  | 2015-11-24    | 002      |


Managing visual clutter and noise is a very underrated part of data work. Be aggressively intolerant about making things as "neat" as possible. Tolerating ugliness feels easier but only because it's harder to notice the cumulative cognitive toll of cognitive overload.


### Style: one column per line

For a short, trivial query, it's probably fine to jam several column identifiers into the same line:


~~~sql
SELECT
  species, name, price
FROM
  pets;
~~~

But for selections of 4 or more columns -- or for columns with really long identifiers -- put the column identifiers on separate lines. You aren't being charged by the whitespace:



~~~sql
SELECT
  owner_id,
  species, 
  name, 
  price
FROM
  pets;
~~~

| owner_id | species | name     | price |
| -------- | ------- | -------- | ----- |
| 001      | dog     | Einstein | 25.0  |
| 001      | cat     | Olly     | 15.0  |
| 005      | dog     | Flipper  | NULL  |
| 004      | dog     | Shaggy   | 42.0  |
| 002      | cat     | Garfield | 20.5  |
| 005      | fish    | Qwerty   | 5.0   |
| 002      | cat     | Pounce   | 30.0  |
| 002      | cat     | Timba    | 25.0  |


### Style: try leading commas

The commas separating column identifiers don't have to follow the preceding token as they do in English. We can separate and space them between column identifiers as we like, including having them at the **beginning** of a new line.

This *leading comma* style looks awkward at first (I'll admit to hating it for a long time), but it ends up resulting in a more orderly line of commas and identifiers:


~~~sql
SELECT
  owner_id
  , species 
  , name 
  , price
FROM
  pets;
~~~

In the **trailing-comma** style, as the list of identifiers get longer, it's very easy to be missing a comma, or not notice that there's an extraneous comma. Both hard-to-see syntax errors cause the interpreter to completely choke:

~~~sql
SELECT
  owner_id
  species,
  name,
  price,
FROM
  pets;
~~~


