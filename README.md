# Simple SQL with simplestuff.sqlite


An example database that is so simple that all of its contents can be printed on this page. But the data and structure is "complex" enough to teach moderately advanced SQL syntax, including self-joins, subqueries, and recursive common-table-expressions.

The data values are meant to be simple enough so that, at a glance, you can mentally compute that a woman named Angela owns two dogs without having to write any SQL, nevermind a JOIN query. So when you *do* learn how to write a SQL join query, you know what answer you're supposed to get.


## The content

**Download the database:**  [simplestuff.sqlite](https://github.com/dannguyen/simplestuff-sqlite/blob/master/simplestuff.sqlite)


- [GROUP BY](lessons/group-by.md)
- [INNER JOIN basics](lessons/inner-join-basics.md)
- [LEFT JOIN basics](lessons/left-join-basics.md)


## About the data

The **simplestuff.sqlite** database consists of 3 relational tables: people, bios, and pets. People each have a `name` and an `id`, they have biographical information, and some of these people own pets.

That's all there's to it. Why is a person's birthdate and gender in a different table -- `bios` -- rather than being columns in the `people` table -- other than to provide convenient examples for JOIN queries? Sometimes -- actually most of the time -- data just isn't conveniently packaged in one file, table, or even database. Knowing SQL and how to JOIN is how we get past those problems.

The schema for the database, i.e. the structure of all 3 tables, can be seen in this file: [schema.sql](schema.sql)

------------

### people


~~~sql
SELECT * FROM people;
~~~

| id  | name    |
| --- | ------- |
| 001 | Angela  |
| 002 | Bill    |
| 003 | Carla   |
| 004 | Darlene |
| 005 | Elliot  |

Pretty straightforward table of "people". Although real people usually have last names,  I left that out to keep things simple. Also, the records in `people` are in order both alphabetically by `name` and by `id`.

And it's worth pointing out that the `id` field is **not** a number, but a text string. 


---------


### bios


~~~sql
SELECT * FROM bios;
~~~

| id  | birthdate  | gender |
| --- | ---------- | ------ |
| 001 | 1988-02-27 | F      |
| 002 | 1964-01-12 | M      |
| 003 | 1975-05-08 | F      |
| 004 | 1990-11-05 | F      |
| 005 | 1986-09-17 | M      |
| 424 | 1991-07-23 | F      |

The `bios` table is connected to `people` via the `id` column.

The biographical records have a *one-to-one relationship with the **people**. In other words, at any given point in time, each person has one, and only one birthdate and gender.

However, this doesn't necessarily mean that *all* records in `bios` have a corresponding person. You can eyeball the last record in `bios` having an outlier value (`424`) for `id` with no corresponding `id` in  `people`.

In real-life databases, these kind of mismatches are not uncommon. Think of deleting a record from one table and forgetting to delete its corresponding related record from the other table. 


----------

### pets

~~~sql
SELECT * FROM pets;
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

The `pets` table, like `bios`, is connected to `people` using the `people.id` field. However, unlike `bios`, the linking column -- also known as the *foreign key* column -- is not named `id` but `owner_id`.

Also, unlike `bios`, `pets` has a **many-to-one** relationship to `people`. A person may own a single pet, in which case it seems like a one-to-one relationship. But another person may own *many* pets. Or *none* at all. 

Note that in the real world, the relationship between people and pets is actually **many-to-many**: Not only can a person have many pets, but a pet may have many owners. But `simplestuff.sqlite` doesn't attempt to model the real world, just a simple one.

One more thing to note: The `price` value for the pet named 'Flipper' is listed as `NULL`:

```
| name     | species | purchase_date | price | owner_id |
| -------- | ------- | ------------- | ----- | -------- |
...
| Flipper  | dog     | 2014-05-09    | NULL  | 005      |
...
```

That is not intended to be a string literal, i.e. to be quoted as in the case of `'Flipper'` and `'dog'` -- but the special value of `NULL`, which is used in SQL to represent *non-existence*. This is not the same as `0` or a blank/empty string. We can think of Flipper as not having been paid for, rather than having been acquired for free or for an unknown value.s
