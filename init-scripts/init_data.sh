#!/bin/bash

# Ensure the log directory exists
mkdir -p /logs

# Log file location
log_file="/logs/mongo_init.log"

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to become ready..." >> $log_file
until mongosh admin --username root --password example --eval "db.adminCommand('ping')" >> $log_file 2>&1
do
    echo "MongoDB not ready, waiting..." >> $log_file
    sleep 5
done
echo "MongoDB is ready!" >> $log_file

# Import data into MongoDB
echo "Starting data import..." >> $log_file

# Import emissions data
mongoimport --username root --password example --authenticationDatabase admin --db mydatabase --collection emissions --type csv --file /data/emissions/schadstoffemissionen_1990-2022_nach_nfr_wide_1a3b1.csv --columnsHaveTypes --fieldFile /data/emissions/fields.txt >> $log_file 2>&1
echo "Emissions data import complete." >> $log_file

# Import new cars data
mongoimport --username root --password example --authenticationDatabase admin --db mydatabase --collection newcars --type csv --file /data/newcars/overalldata_new.csv --columnsHaveTypes  --fieldFile /data/newcars/fields.txt >> $log_file 2>&1
echo "New cars data import complete." >> $log_file

# Import used cars data
mongoimport --username root --password example --authenticationDatabase admin --db mydatabase --collection usedcars --type csv --file /data/usedcars/overalldata_used.csv --columnsHaveTypes  --fieldFile /data/usedcars/fields.txt >> $log_file 2>&1
echo "Used cars data import complete." >> $log_file


echo "All data imports are done." >> $log_file


