# frozen_string_literal: true
module Utils
  module Validation
    EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

    def present?(str)
      !str.nil? && !str.strip.empty?
    end

    def valid_email?(email)
      !!(email =~ EMAIL_REGEX)
    end

    def valid_iata?(code)
      !!(code && code.match?(/\A[A-Z]{3}\z/))
    end

    def time_order?(start_t, end_t)
      start_t && end_t && start_t < end_t
    end
  end
end
