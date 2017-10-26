# Simple SQL with simplestuff.sqlite


An example database that is so simple that all of its contents can be printed on this page. But the data and structure is "complex" enough to teach moderately advanced SQL syntax, including self-joins, subqueries, and recursive common-table-expressions.

The data values are meant to be simple enough so that, at a glance, you can mentally compute that a woman named Angela owns two dogs without having to write any SQL, nevermind a JOIN query. So when you *do* learn how to write a SQL join query, you know what answer you're supposed to get.


## The stuff

Download the database here: [simplestuff.sqlite](simplestuff.sqlite)

Some examples:

- Hello



## About the data

The **simplestuff.sqlite** database consists of 3 relational tables: people, bios, and pets. People each have a `name` and an `id`, they have biographical information, and some of these people own pets.

That's all there's to it. Why is a person's birthdate and gender in a different table -- `bios` -- rather than being columns in the `people` table -- other than to provide convenient examples for JOIN queries? Sometimes, actually most of the time, data just isn't conveniently 



### people


~~~sql
SELECT * FROM people;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 002 | Bill    |
| 003 | Colby   |
| 004 | Darlene |
| 005 | Elliot  |

Pretty straightforward table of "people". Although real people usually have last names,  I left that out to keep things simple. Also, the records in `people` are in order both alphabetically by `name` and by `id`.

And it's worth pointing out that the `id` field is **not** a number, but a text string. 



### bios


~~~sql
SELECT * FROM bios;
~~~

| id  | birthdate  | gender |
| --- | ---------- | ------ |
| 001 | 1988-02-27 | F      |
| 002 | 1964-01-12 | M      |
| 003 | 1955-05-08 | M      |
| 004 | 1990-11-05 | F      |
| 005 | 1986-09-17 | M      |
| 424 | 1991-07-23 | F      |

The `bios` table is connected to `people` via the `id` column.

The biographical records have a one-to-one relationship with people, i.e. at a given point in time, each person has one, and only one birthdate and gender.

However, that doesn't mean that all records in `bios` have a corresponding person, which you can probably eyeball as no record in `people` has an `id` of `'424'`. Mismatches like this happen all the time in real-world databases.


### pets

~~~sql
SELECT * FROM pets;
~~~

| owner_id | name     | species | purchase_date | purchase_price |
| -------- | -------- | ------- | ------------- | -------------- |
| 001      | Einstein | dog     | 2006-10-21    | 25.0           |
| 001      | Olly     | cat     | 2012-03-12    | 15.0           |
| 005      | Flipper  | dog     | 2014-05-09    | 25.75          |
| 004      | Shaggy   | dog     | 1997-12-15    | 42.0           |
| 002      | Garfield | cat     | 1990-01-03    | 20.5           |
| 005      | Qwerty   | fish    | 2012-03-12    | 5.0            |
| 002      | Pounce   | cat     | 2001-04-17    | 30.0           |
| 002      | Timba    | cat     | 2015-11-24    | 25.0           |


The `pets` table, like `bios`, is connected to `people` via the `people.id` field. However, unlike `bios`, the linking column -- aka the *foreign key* column -- is not named `id` but `owner_id`.

Also unlike `bios`, `pets` has a many-to-one relationship to `people`. Some people own one pet, some own multiple, and some own none. Though if you think about it, pets and people in the real world could be a many-to-many relationship, i.e. a dog having more than one owner. But the `simplestuff.sqlite` database exists in a very simple world.




