<a className="gh-badge" href="https://datahub.io/core/currency-codes"><img src="https://badgen.net/badge/icon/View%20on%20datahub.io/orange?icon=https://datahub.io/datahub-cube-badge-icon.svg&label&scale=1.25" alt="badge" /></a>

List of currencies and their 3 digit codes as defined by [ISO 4217][iso-4217]. The data
provided here is the consolidation of Table A.1 "Current currency & funds code list" (SIX now calls it "List One") and
Table A.3 "Historic denominations" (SIX now calls it "List Three").

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
| `Entity` | Country or other entity that uses the currency (upper case, as in the source). Also holds `ZZ..` rows for funds and metals (for example `ZZ08_Gold`) and a few international bodies (for example `EUROPEAN UNION`) |
| `Currency` | Currency name |
| `AlphabeticCode` | 3-letter code, for example `EUR` |
| `NumericCode` | 3-digit code with leading zeros, for example `008`. Read it as text |
| `MinorUnit` | Number of decimal digits. `-` means the source says "N.A." (for example `XAU` and `XDR`). Empty for withdrawn currencies (Table A.3 has no minor unit) and for the current entries that have no currency |
| `WithdrawalDate` | Empty for current currencies. Otherwise `YYYY-MM`, or a range such as `1990-07 to 1990-09` |

What to know before using it:

* Current currencies come from A.1 and withdrawn ones from A.3; withdrawn rows have `WithdrawalDate` filled.
* A code can repeat: `EUR` is used by many entities, and some (Entity, code) pairs appear twice because the currency was renamed
  (for example Malawi `MWK` and Peru `PEN`). So neither the code nor (Entity, code) is a unique key.
* Some entities have no codes at all, because the source says "No universal currency" (for example Antarctica). Some withdrawn
  funds codes (for example `XFO`) have an alphabetic code but no numeric code.

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

The two XML files in `./archive` are old copies of the source files, last updated in October 2024. The script does not update them. `archive/table_a1.xml` is Table A.1 (published 2024-06-25). `archive/table_a2.xml` is Table A.3, not a second copy of A.1: the file name says "a2", but its content is the historic list (published 2024-09-01).

## License

The licence of the underlying data is unclear.

What we checked:

* SIX Group, the ISO 4217 maintenance agency, publishes the lists free of charge on its data standards page.
* We found no licence and no reuse terms for the XML files. The two files carry no copyright or licence notice.
* SIX's website terms say the content of the SIX website is protected by copyright and may not be reproduced or reused, or used for commercial purposes. It is unclear whether this covers the XML downloads. The terms do not name them.
* ISO states that it "allows free-of-charge use of its country, currency and language codes from ISO 3166, ISO 4217 and ISO 639". We read this on an archived copy of the ISO page (December 2024). ISO's current copyright page could not be read, so we could not confirm what it says today.

What we could not establish: whether the lists may be republished in a public repository or used commercially.

The maintainers of this repository place only their own work (the combination of the two lists and the CSV format) under the Public Domain Dedication and License (PDDL). This does not cover the ISO 4217 lists themselves.

If you plan commercial use, check the terms of SIX Group and ISO first. See also `ATTRIBUTION.txt`.

