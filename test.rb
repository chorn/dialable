#!/usr/bin/env ruby

require "rubygems"
require "lib/dialable"

pn = Dialable::NANP.parse("+1(307)555-1212 ext 1234")

ap pn
