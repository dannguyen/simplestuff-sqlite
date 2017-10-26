DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS bios;

CREATE TABLE people(
    id TEXT,
    name TEXT
);


CREATE TABLE bios(
    id TEXT,
    birthdate TEXT,
    gender TEXT
);


CREATE TABLE pets(
    owner_id TEXT,
    name TEXT,
    species TEXT,
    purchase_date TEXT,
    purchase_price REAL
);

