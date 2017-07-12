# countries-alphanumeric-sms-sender-support
Support of sender in alphanumeric format,
based on international phone number prefix

## Objectives

The goal of this project is to determine whether an international phone
number can be the destination of a Short Message Service (SMS) message
using a sender in alphanumeric format.

Support for alphanumeric senders depends on the country and in at least
one case (Japan) on the telecom operator.

## Processing Chain

1. initialize and/or update the git submodule datasets/countrycodes:

```
git submodule init
git submodule update
```

2. retrieve alpha sender support from Twilio

```
cd data/twilio
npm install
node scrape.json
cd -
```

3. create mapping from country names to ISO2 country codes

```
./data/twilio-mapping/map.sh
```

Note that the file `data/twilio-mapping/step4/aliases.csv`
must be edited by hand to associate country names which do not match
between Twilio source and the country codes source. The file needs only
to be updated when new names in Twilio source fail to match.

4. join and refine data to produce the final file

```
./data/country-dial-codes/join.sh
```

This produces the file `alphasendersupport.csv` at the root of this project.
This file includes one line for each dial code prefix and country (at least
one country has several prefixes, and thus appears multiple times), and
indicates whether this country supports alphanumeric senders for SMS messages:

  * always (`yes`)
  * never (`no`)
  * with exceptions (`partial`)

Note that dial codes may be shared by several countries, and that some
prefixes are longer than other, e.g. `1` for `CA`, `PR`, `US` has no alpha
support, while `1242` for `BS` also starts with `1` but has alpha support.

## References

* [Twilio > Help Center > International support for Alphanumeric Sender ID](https://support.twilio.com/hc/en-us/articles/223133767-International-support-for-Alphanumeric-Sender-ID)
* [GitHub > Data Packaged Core Datasets > country-codes > country-codes.csv](https://github.com/datasets/country-codes/blob/master/data/country-codes.csv)
* [Wikipedia > List of country calling codes](https://en.wikipedia.org/wiki/List_of_country_calling_codes)
* [Wikipedia > Telephone numbers in Japan](https://en.wikipedia.org/wiki/Telephone_numbers_in_Japan)

## Software License

Copyright 2017 eGull SAS  
Licensed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
