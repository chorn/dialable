# dialable

[![Gem Version](https://badge.fury.io/rb/dialable.svg)](https://badge.fury.io/rb/dialable)
[![Build Status](https://travis-ci.org/chorn/dialable.svg?branch=master)](https://travis-ci.org/chorn/dialable)

## A gem that provides parsing and output of phone numbers according to NANPA standards.

### This gem does not provide a validation for Rails.

Phone numbers are not a big deal if you can validate the input at the
time you've got a human right there.  My enterprise tends not to have
that ability, as we receive large files from clients with little or no
validation done.  Rather than abandon #s which don't validate, I wrote
this to parse and normalize a string into a standard NANP phone
number, possibly including an extension.

## Usage and Features

```ruby
$ irb
>> require "dialable"
>> pn = Dialable::NANP.parse("+1(800)555-1212 ext 1234")
>> puts pn.to_s         # Pretty output
800-555-1212 x1234
>> puts pn.to_digits    # Address book friendly
8005551212 x1234
>> puts pn.to_dialable  # PBX friendly
8005551212
>> puts pn.extension
1234
```

### Timezones and Timezone relative offsets

For `v1.0.0`, the timezone syntax from dialable has changed to output `tzinfo` compatible names.


Also, pn.timezones and pn.relative_timezones should do the right thing.


## Data

The YAML file with the valid area codes and easily recognizable codes
(like 911) can get out of date.  To update your own copy, run:

```sh
cd $(dirname $(gem which dialable)) ; cd ..
ruby ./support/make_yaml_nanpa.rb > data/dialable/nanpa.yaml
```

## References

* [North American Numbering Plan Administration (NANPA)](http://nanpa.com/ "NANPA")
* [NPA Report](http://nanpa.com/nanp1/npa_report.csv "CSV")
* [NPA Report Data Dictionary](http://nanpa.com/area_codes/AreaCodeDatabaseDefinitions.xls "AreaCodeDatabaseDefinitions.xls")
