## map.sh
Produce a mapping of country names used in
[Twilio list of countries and their support for alphanumeric sender id]
(https://support.twilio.com/hc/en-us/articles/223133767)
with the corresponding alpha2 ISO country codes.

## Note

This process is only partly automated. The matching had to be fine-tuned
by hand to account for differences in spelling, formatting and even changes
of territory names over time.

### Requirement

* [csvkit](https://github.com/wireservice/csvkit) version 1.0.1 or compatible

### Usage

```
./map.sh
```

### Output

* `country_mapping.csv` - mapping of country names to alpha2 ISO country codes
