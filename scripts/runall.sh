#!/bin/bash

set -euo pipefail

# Check if xmllint is installed
if ! command -v xmllint &> /dev/null
then
    echo "Error: xmllint is not installed."
    exit 1
fi

# Force UTF-8 encoding
export LC_ALL=en_US.UTF-8
LANG=C.UTF-8

# extract currency-code data

# where to extract data to
outdir=../data
if [[ ! -d $outdir ]]; then
  mkdir $outdir
fi
outfile=${outdir}/codes-all.csv

# download tables
if [ ! -d ./cache ]; then
  mkdir cache
fi;
echo Downloading XML files...
curl -s -o cache/a1.xml "https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml"
curl -s -o cache/a2.xml "https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-three.xml"

# write headers
echo "Entity,Currency,AlphabeticCode,NumericCode,MinorUnit,WithdrawalDate" > ${outfile}

# loop through files
for (( i = 0; i < 2 ; i++ ))
do
  # set node names/file
  if [ $i == 0 ]; then
    declare -a nodes=("CtryNm" "CcyNm" "Ccy" "CcyNbr" "CcyMnrUnts" "WthdrwlDt")
    f=cache/a1.xml  # A1 table file
    tblroot=/ISO_4217/CcyTbl # where entries are
    rowname=CcyNtry
  else
    declare -a nodes=("CtryNm" "CcyNm" "Ccy" "CcyNbr" "CcyMnrUnts"  "WthdrwlDt")  # empty columns
    f=cache/a2.xml
    tblroot=/ISO_4217/HstrcCcyTbl
    rowname=HstrcCcyNtry
  fi

  # get all rows
  xmllint --xpath "${tblroot}/${rowname}" --encode UTF-8 $f > cache/tmp
  # remove line endings (one big line)
  sed -i.tmp -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' cache/tmp
  # remove tabs
  sed -i.tmp 's/\t//g' cache/tmp
  # separate each row to new line
  sed -i.tmp  "s/<\/${rowname}>/\n/g" cache/tmp

  # loop of rows
  echo "Reading $f"
  c=1
  while read LINE
  do
    LSPLIT=`echo "$LINE" | sed -e "s/>/>\n/g" -e "s/<\//\n<\//g" | sed "s/^ //g"`

    # look for each column
    a=""  # csv line
    for (( j = 0 ; j < ${#nodes[@]} ; j++ ))
    do
      nn=${nodes[$j]}
      valq=`echo "$LSPLIT" | sed -nr "/<${nn}(\sIsFund=.*)?>/,/<\/${nn}>/p" | sed '$d' | tail -n +2`
      val=`echo "$valq" | sed "s/\"/\"\"/g"`

      if [[ ! -z $val ]]; then
        if [[ $val == *,* || $val != $valq ]]; then
          val="\"${val}\""  # val needs to be quoted
        fi
      fi

      if [[ $val == 'N.A.' ]]; then
        val="-"
      fi

      if [[ -z $a ]]; then
        a="$val"
      else
        a="${a},${val}"
      fi
    done

    # Check if the row is non-empty before writing to the CSV
    if [[ -n "$a" ]]; then
      echo "$a" >> ${outfile}
    fi

    c=$(($c + 1))
    if [ $(($c % 10)) = 0 ]; then
      echo -n "."
    fi
  done < cache/tmp
  echo " "
done

# convert special entities and ensure UTF-8 output
iconv -f ISO-8859-1 -t UTF-8 "${outfile}" > "${outfile}.utf8"
mv "${outfile}.utf8" "${outfile}"

# clean up
rm -r cache/
echo complete
