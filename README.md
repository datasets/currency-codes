List of currencies and their 3 digit codes as defined by [ISO 4217][iso-4217]. The data
provided here is the consolidation of Table A.1 "Current currency & funds code list" and
Table A.3 "Historic denominations".

Note that the [ISO page][iso-4217] offers pay-for PDFs but also links to
<http://www.currency-iso.org/en/home/tables.html> which does provide them in machine
readable form freely.

[iso-4217]: http://www.currency-iso.org/en/home/tables.html

## Data

The data provided (see data/codes.csv) in this data package provides a
consolidated list of currency (and funds) codes by combining these two
separate tables:

* [ISO Tables A.1 - Current Currencies and Funds][a1]
* [ISO Tables A.3 - List of codes for historic denominations of currencies & funds][a3]

[a1]: http://www.currency-iso.org/en/home/tables/table-a1.html
[a3]: http://www.currency-iso.org/en/home/tables/table-a3.html

## Preparation

The script requires recode package to be istalled. Install it by running:

`sudo apt install recode`

Run the following script to download and convert the data from XML to
CSV:

```
cd scripts/
./runall.sh
```

The raw XML files are stored in `./archive`. The cleaned data are
`./data/codes-all.csv`.

## Version

The current tables have a published date of 28 March 2014 (as indicated
in the XML files).

## License

Placing in the Public Domain under the Public Domain Dedication and License.
The original site states no restriction on use and the data is small and
completely factual.

