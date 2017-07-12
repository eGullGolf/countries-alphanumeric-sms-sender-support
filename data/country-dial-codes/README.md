## join.sh
Produce a list of dial codes of countries associated with their support
for alphanumeric sender id on 3 levels: yes, no, or partial (with exceptions).

### Requirement

* [csvkit](https://github.com/wireservice/csvkit) version 1.0.2 or compatible

### Usage

```
./join.sh
```

### Output

* `country_mapping.csv` - mapping of country names to alpha2 ISO country codes
