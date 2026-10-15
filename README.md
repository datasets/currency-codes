<a className="gh-badge" href="https://datahub.io/core/currency-codes"><img src="https://badgen.net/badge/icon/View%20on%20datahub.io/orange?icon=https://datahub.io/datahub-cube-badge-icon.svg&label&scale=1.25" alt="badge" /></a>

List of currencies and their 3 digit codes as defined by [ISO 4217][iso-4217]. The data
provided here is the consolidation of Table A.1 "Current currency & funds code list" and
Table A.3 "Historic denominations".

Note that ISO offers pay-for PDFs, but [SIX Group's data standards page][iso-4217] (SIX Group is the ISO 4217 maintenance agency) provides the same lists in machine readable form freely.

[iso-4217]: https://www.six-group.com/en/products-services/financial-information/market-reference-data/data-standards.html

## Data

The data provided (see data/codes-all.csv) in this data package provides a
consolidated list of currency (and funds) codes by combining these two
separate tables:

* [ISO Tables A.1 - Current Currencies and Funds][a1]
* [ISO Tables A.3 - List of codes for historic denominations of currencies & funds][a3]

[a1]: https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml
[a3]: https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-three.xml

Columns of `data/codes-all.csv`:

| Column | Meaning |
|---|---|
| `Entity` | Country or other entity that uses the currency (upper case, as in the source). Also holds 13 `ZZ..` rows for funds and metals (for example `ZZ08_Gold`) and a few international bodies (for example `EUROPEAN UNION`) |
| `Currency` | Currency name |
| `AlphabeticCode` | 3-letter code, for example `EUR` |
| `NumericCode` | 3-digit code with leading zeros, for example `008`. Read it as text |
| `MinorUnit` | Number of decimal digits. `-` means the source says "N.A." (13 rows, such as `XAU` and `XDR`). Empty on withdrawn rows, because Table A.3 has no minor unit |
| `WithdrawalDate` | Empty for current currencies. Otherwise `YYYY-MM`, or a range such as `1990-07 to 1990-09` |

What to know before using it:

* 449 rows: 280 current (from A.1) and 169 withdrawn (from A.3, `WithdrawalDate` filled).
* 307 distinct alphabetic codes. A code can repeat: `EUR` is used by many entities, and 6 (Entity, code) pairs appear twice because the currency was renamed
  (Malawi `MWK`, Peru `PEN`, Romania `RON`, Croatia `HRK`, Venezuela `VEF`, Zimbabwe `ZWD`). So neither the code nor (Entity, code) is a unique key.
* 3 rows have no codes at all: Antarctica, Palestine (State of), and South Georgia and the South Sandwich Islands ("No universal currency"). 3 more withdrawn
  funds codes (`XFO`, `XRE`, `XFU`) have an alphabetic code but no numeric code.

## Preparation

The script needs `bash`, `curl`, `sed` and `xmllint` (from the `libxml2-utils` package). It works with GNU sed (Linux) and with the macOS sed. On Debian/Ubuntu install `xmllint` by running:

`sudo apt install libxml2-utils`

Run the following script to download and convert the data from XML to
CSV:

```
cd scripts/
./runall.sh
```

The script downloads the two XML files into a temporary `scripts/cache/` folder and deletes it when it is done. The cleaned data are written to
`./data/codes-all.csv`. A GitHub workflow runs the script on the 1st of every month and commits the file if it changed.

The two XML files in `./archive` are old snapshots (Table A.1 published 2024-06-25, Table A.3 published 2024-09-01), last updated in October 2024. The script does not update them.

## License

Placing in the Public Domain under the Public Domain Dedication and License.
The original site states no restriction on use and the data is small and
completely factual.

