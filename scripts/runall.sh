#!/bin/bash
# extract currency-code data

# check for required functions
command -v recode >/dev/null 2>&1 || { echo "Script requires 'recode' package. Aborting"; exit 1; }
command -v sed >/dev/null 2>&1 || { echo "Script requires 'sed' package. Aborting"; exit 1; }

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
curl -s -o cache/a1.xml "http://www.currency-iso.org/dam/downloads/table_a1.xml"
curl -s -o cache/a2.xml "http://www.currency-iso.org/dam/downloads/table_a3.xml"

# write headers
echo "Entity,Currency,AlphabeticCode,NumericCode,MinorUnit,WithdrawalDate,Remark" > ${outfile}

# loop through files
for (( i = 0; i < 2 ; i++ ))
do
  # set node names/file
  if [ $i == 0 ]; then
    declare -a nodes=("CtryNm" "CcyNm" "Ccy" "CcyNbr" "CcyMnrUnts")
    f=cache/a1.xml  # A1 table file
    tblroot=/ISO_4217/CcyTbl # where entries are
    rowname=CcyNtry
  else
    declare -a nodes=("CtryNm" "CcyNm" "Ccy" "CcyNbr" ""  "WthdrwlDt")  # empty columns
    f=cache/a2.xml
    tblroot=/ISO_4217/HstrcCcyTbl
    rowname=HstrcCcyNtry
  fi

  # get all rows
  xmllint --xpath "${tblroot}/${rowname}" $f > cache/tmp
  # remove line endings (one big line)
  sed -i.tmp -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' cache/tmp
  # remove tabs
  sed -i.tmp 's/\t//g' cache/tmp
  # separte each row to new line
  sed -i.tmp  "s/<\/${rowname}>/\n/g" cache/tmp

  # loop of rows
  echo "Reading $f"
  c=1
  while read LINE
  do
    # break up row into lines
    #LSPLIT=`echo "$LINE" | sed "s/>/>\n/g" | sed "s/<\//\n<\//g" | sed "s/^ //g"`
    LSPLIT=`echo "$LINE" | sed -e "s/>/>\n/g" -e "s/<\//\n<\//g" | sed "s/^ //g"`

    # look for each column
    a=""  # csv line
    for (( j = 0 ; j < ${#nodes[@]} ; j++ ))
    do
      # search for this tag
      nn=${nodes[$j]}
      valq=`echo "$LSPLIT" | sed -nr "/<${nn}(\sIsFund=.*)?>/,/<\/${nn}>/p" | head -n-1 | tail -n+2`
      val=`echo "$valq" | sed "s/\"/\"\"/g"`  # replace single double quote with double double quote

      # check for a quote or comma in val, if non-empty
      if [[ ! -z $val ]]; then
        if [[ $val == *,* || $val != $valq ]]; then
          val="\"${val}\""  # val needs to be quoted
        fi
      fi

      # concat to csv row
      if [[ -z $a ]]; then
        # first column
        a="$val"
      else
        # non-first column
        a="${a},${val}"
      fi
    done

    # append line to file
    echo "$a" >> ${outfile}

    # count files, print status
    c=$(($c + 1))
    if [ $(($c % 10)) = 0 ]; then
      echo -n "."
    fi
  done < cache/tmp
  echo " "
done

# convert HTML special entities to UTF-8
recode html..utf8 ${outfile} # convert in place

# move raw data to archive
if [[ ! -d ../archive ]]; then
  mkdir ../archive
fi
mv cache/a1.xml ../archive/table_a1.xml
mv cache/a2.xml ../archive/table_a2.xml

# clean up
rm -r cache/
echo complete
