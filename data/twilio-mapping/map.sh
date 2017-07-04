#!/bin/sh
# Map country names to alpha2 ISO country codes
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

inputCountries='../twilio/country_alpha_support.csv'
inputAlpha2='../../datasets/country-codes/data/country-codes.csv'

countriesNameColumn=1
alpha2NameColumn=1
alpha2Column=4

echo 'step 1: select only columns of interest'
csvcut -c "$countriesNameColumn" "$inputCountries" > step1/names.csv
csvcut -c "$alpha2NameColumn,$alpha2Column" "$inputAlpha2" > step1/alpha2.csv

echo 'step 2: attempt exact mapping'
csvjoin -c 1,1 --left --blanks step1/names.csv step1/alpha2.csv \
> step2/names_alpha2.csv

echo 'step 3: separate rows with matches from rows without matches'
csvgrep -c2 -r'.' step2/names_alpha2.csv > step3/match.csv
csvgrep -c2 -r'^$' step2/names_alpha2.csv > step3/nomatch.csv

echo 'step 4: use handmade aliases to map rows which did not match previously'
csvjoin -c 2,1 --left --blanks step4/aliases.csv step1/alpha2.csv \
> step4/rematch.csv

echo 'step 5: merge first time and second time matches'
csvcut -c 1,3 step4/rematch.csv > step5/rematch.csv
csvstack step3/match.csv step5/rematch.csv \
| csvsort -c1 --blanks > step5/names_alpha2.csv

echo 'look for missing matches, if any'
csvgrep -c2 -r'^$' step5/names_alpha2.csv > step5/nomatch.csv
if test "$( wc -l < step5/nomatch.csv )" -gt 1
then
  echo 'ERROR: missing matches:'
  cat step5/nomatch.csv
  echo
  echo 'Please customize handmade mapping file step4/aliases.csv'
  echo 'before running the mapping script again.'
  exit
fi

echo 'copy final mapping at the script level'
cp -p step5/names_alpha2.csv country_mapping.csv
