# Using SEC Filing data with LittleSis

`lib/sec.rb` contains a library to download and parse sec filings. There is a command-line client at `lib/scripts/sec`. 

View options: ` ./lib/scripts/sec --help`

## Creating the sec index database

Unlike most of LittleSis's data, SEC filings are stored in a database. By default that data is located at `<RailsRoot>/data/sec_filings.db`.

The database must be created before you can explore the database.


**Create SEC index csv**: ` lib/scripts/sec_download_index `

This will download and parse the SEC index files save a csv in the same folder you ran the command from. It will save a file that will look like this: sec\_index\_2014-2019-09-23.csv


**Create SEC Database**: ` lib/scripts/sec_create_database [path-to-csv] `

This creates a sqlite3 database (`sec_filings.db`) from the index files. 


## CLI examples

These examples use Amazon's CIK 0001018724. You can use any CIK or predefined example CIK. View available examples:

``` 
lib/scripts/sec --list-example-ciks
```

### List forms by type
 
```
lib/scripts/sec  --cik 0001018724 --print-forms --forms=8-K
```

###  Roaster


View roaster of names

```
lib/scripts/sec --cik 0001018724 --roster
```

View roaster in json format

```
lib/scripts/sec --cik 0001018724 --roster --json
```
