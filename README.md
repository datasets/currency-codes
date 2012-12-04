List of currencies and their 3 digit codes as defined by [ISO 4217][iso-4217]. The data
provided here is the consolidation of Table A.1 Current currency & funds code list

Note that the [ISO page][iso-4217] offers pay-for PDFs but also links to
<http://www.currency-iso.org/iso_index/> which does provide them in machine
readable form freely.

[iso-4217]: http://www.iso.org/iso/currency_codes

## Data

The data provided (see data/codes.csv) in this data package provides a
consolidated list of currency (and funds) codes by combining these two
separate tables: 

* [ISO Tables A.1 - Current Currencies and Funds][a1]
* [ISO Tables A.3 - List of codes for historic denominations of currencies & funds][a3]

Specifically the steps taken are:

* Obtain the XLS files for Table A.1 and A.3
* Convert to CSV
* Concatenate (merging headings)

[a1]: http://www.currency-iso.org/iso_index/iso_tables/iso_tables_a1.htm
[a3]: http://www.currency-iso.org/iso_index/iso_tables/iso_tables_a3.htm

## License

Placing in the Public Domain under the Public Domain Dedication and License.
The original site states no restriction on use and the data is small and
completely factual.

