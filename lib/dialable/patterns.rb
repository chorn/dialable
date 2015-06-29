module Dialable
  module Patterns

    # Regexs to match valid phone numbers
    NANP = [
      /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*[ex]+\D*(\d{1,5})\D*$/i,
      /^\D*1?\D*([2-9]\d\d)[ $\\\.-]*(\d{3})[ $\\\.-]*(\d{4})[ $\\\.\*-]*(\d{1,5})\D*$/i,
      /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*$/,
      /^(\D*)(\d{3})\D*(\d{4})\D*$/,
      /^\D*([2-9]11)\D*$/,
      /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D.*/  # Last ditch, just find a number
      ]

  end
end
