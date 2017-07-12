#!/bin/sh
# Join Twilio Alphanumeric sender support with country codes and dial codes
#
# License:
#   Copyright 2017 eGull SAS
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
cd "$(dirname "$0")"

inputAlphaSender='../twilio/country_alpha_support.csv'
inputCountryCodes='../twilio-mapping/country_mapping.csv'
inputDialCodes='../../datasets/country-codes/data/country-codes.csv'

echo 'step 1: select columns of interest before join'
csvcut -c 'COUNTRY,ALPHA SUPPORT' "$inputAlphaSender" > step1/alphasender.csv
csvcut -c 'ISO3166-1-Alpha-2,Dial' "$inputDialCodes" > step1/dialcodes.csv

echo 'step 2: refine data: split lists of dial codes into separate records'
awk -F'"' -f - step1/dialcodes.csv > step2/dialcodes.csv << 'AWK'
NF==1 {print; next}
{ split($2, dialCodes, ",");
  for ( position in dialCodes ) {
    print $1 dialCodes[position]
  }
}
AWK

echo 'step 3: reformat data: change alpha support to yes|no|partial'
awk -F',' -f - step1/alphasender.csv > step3/alphasender.csv << 'AWK'
NR==1 { print; next }
$2!="Yes" && $2!="No" {$2 = "Partial"}
{print $1 "," tolower($2)}
AWK

echo "step 3: reformat data: remove '-' from dial codes"
awk -F',' -f - step2/dialcodes.csv > step3/dialcodes.csv << 'AWK'
BEGIN {OFS=","}
{ gsub("-","",$2);
  print
}
AWK

echo 'step 4: join alpha sender support with country codes'
csvjoin --blanks \
  --columns 'COUNTRY,COUNTRY' \
  step3/alphasender.csv \
  "$inputCountryCodes" \
> step4/alphasender_with_countrycodes.csv

echo 'step 4: join further with dial codes'
csvjoin --blanks \
  --columns 'ISO3166-1-Alpha-2,ISO3166-1-Alpha-2' \
  step4/alphasender_with_countrycodes.csv \
  step3/dialcodes.csv \
> step4/alphasender_with_dialcodes.csv

echo 'step 5: select and reorder columns, sort records'
csvcut --columns 'Dial,ISO3166-1-Alpha-2,ALPHA SUPPORT' \
  step4/alphasender_with_dialcodes.csv \
| csvsort \
> step5/alphasendersupport.csv

echo 'copy final file to the script level'
cp -p step5/alphasendersupport.csv .

echo 'copy final file to the root of the project'
cp -p ./alphasendersupport.csv ../..
