DB_NAME='db/simplestuff.sqlite'

sqlite3 $DB_NAME < db/schema.sql

for tbl in people pets bios; do
  echo "Inserting data for $tbl"
  csvsql --db sqlite:///${DB_NAME} \
         --no-create --insert \
         --no-inference \
         --tables ${tbl} \
         data/${tbl}.csv
done



