module Dialable
  module Patterns

    # Regexs to match valid phone numbers
    NANP = [
      Regexp.new('^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*[ex]+\D*(\d{1,5})\D*$', Regexp::IGNORECASE),
      Regexp.new('^\D*1?\D*([2-9]\d\d)[ $\\\.-]*(\d{3})[ $\\\.-]*(\d{4})[ $\\\.\*-]*(\d{1,5})\D*$', Regexp::IGNORECASE),
      Regexp.new('^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*$'),
      Regexp.new('^(\D*)(\d{3})\D*(\d{4})\D*$'),
      Regexp.new('^\D*([2-9]11)\D*$'),
      Regexp.new('^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D.*')  # Last ditch, just find a number
    ]

  end
end
