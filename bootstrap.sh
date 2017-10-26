DB_NAME='simplestuff.sqlite'

sqlite3 $DB_NAME < schema.sql


csvsql --db sqlite:///${DB_NAME} \
       --no-create --insert \
       --no-inference \
       --tables people \
       data/people.csv


csvsql --db sqlite:///${DB_NAME} \
       --no-create --insert \
       --no-inference \
       --tables pets \
       data/pets.csv


csvsql --db sqlite:///${DB_NAME} \
       --no-create --insert \
       --no-inference \
       --tables bios \
       data/bios.csv
