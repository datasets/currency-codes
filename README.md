<a className="gh-badge" href="https://datahub.io/core/currency-codes"><img src="https://badgen.net/badge/icon/View%20on%20datahub.io/orange?icon=https://datahub.io/datahub-cube-badge-icon.svg&label&scale=1.25" alt="badge" /></a>

# ISO 4217 Currency Codes

Currency codes as defined by ISO 4217, in one CSV file: the current currencies and funds (Table A.1, which SIX calls "List One") and the historic denominations that have been withdrawn (Table A.3, "List Three").

Column definitions and types are in `datapackage.json`.

## Data

`data/codes-all.csv` has one row per entity and currency:

| Column | Meaning |
|---|---|
| `Entity` | Country or other entity that uses the currency, in upper case as in the source. Also holds `ZZ..` rows for funds and metals (for example `ZZ08_Gold`) and some international bodies (for example `EUROPEAN UNION`) |
| `Currency` | Currency name |
| `AlphabeticCode` | 3-letter code, for example `EUR` |
| `NumericCode` | 3-digit code with leading zeros, for example `008` |
| `MinorUnit` | Number of decimal digits. `-` where the source says "N.A." (for example `XAU`, `XDR`). Empty for withdrawn currencies (Table A.3 has no minor unit) and for entities with no currency |
| `WithdrawalDate` | Empty for current currencies. Otherwise `YYYY-MM`, or a range such as `1990-07 to 1990-09` |

### Known limitations

* Neither `AlphabeticCode` nor (`Entity`, `AlphabeticCode`) is a unique key. A code is shared by many entities (for example `EUR`), and some pairs appear twice because the currency was renamed (for example Malawi `MWK`, Peru `PEN`).
* Some entities have no codes at all, because the source says "No universal currency" (for example Antarctica). Some withdrawn funds codes (for example `XFO`) have an alphabetic code but no numeric code.
* Read `NumericCode` as text. Read as a number, `008` becomes `8`. With pandas: `pd.read_csv("data/codes-all.csv", dtype=str, keep_default_na=False)`, or use the types in `datapackage.json`.

## Data sources

* ISO 4217 code lists, published free of charge by [SIX Group][six], the ISO 4217 maintenance agency: [List One, current currencies][a1] and [List Three, historic denominations][a3]. Licence: unclear (see [License](#license)).

Changes made to the source data: the two XML lists are combined into one CSV file. For each entry the entity, currency name, alphabetic code, numeric code, minor unit and withdrawal date are kept. "N.A." in the minor unit is written as `-`. Current and withdrawn entries are told apart by `WithdrawalDate`.

Not endorsed by, or affiliated with, SIX Group or ISO.

[six]: https://www.six-group.com/en/products-services/financial-information/market-reference-data/data-standards.html
[a1]: https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml
[a3]: https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-three.xml

## Preparation

The script needs `bash`, `curl`, `sed` and `xmllint` (from the `libxml2-utils` package). It works with GNU sed (Linux) and with the macOS sed. On Debian or Ubuntu:

```
sudo apt install libxml2-utils
```

To download the two XML lists and rebuild `data/codes-all.csv`:

```
cd scripts/
./runall.sh
```

The script downloads the XML files into a temporary `scripts/cache/` folder and deletes it when it is done.

A GitHub workflow runs the script on the 1st of every month and commits `data/codes-all.csv` if it changed.

The two XML files in `archive/` are old copies of the source lists kept for reference. The script does not update them. `archive/table_a1.xml` is Table A.1 (published 2024-06-25); `archive/table_a2.xml` is Table A.3, not a second copy of A.1 (published 2024-09-01).

## License

The licence of the ISO 4217 lists is unclear. What we checked:

* SIX Group publishes the lists free of charge on its data standards page. We found no licence or reuse terms for the XML files, and the files carry no copyright or licence notice.
* SIX's website terms say the content of the SIX website is protected by copyright and may not be reproduced, reused or used for commercial purposes. They do not say whether this covers the XML downloads.
* ISO states that it "allows free-of-charge use of its country, currency and language codes from ISO 3166, ISO 4217 and ISO 639" (read on an archived copy of the ISO page, December 2024; ISO's current page could not be read).

We could not establish whether the lists may be republished or used commercially. If you plan commercial use, check the terms of SIX Group and ISO first.

The maintainers place only their own work (the combination of the two lists and the CSV format) under the [Public Domain Dedication and License (PDDL)](https://opendatacommons.org/licenses/pddl/1.0/). This does not cover the ISO 4217 lists themselves. See also [ATTRIBUTION.txt](ATTRIBUTION.txt).
