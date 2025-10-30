# frozen_string_literal: true
require 'utils/validation'

module Models
  # Airport with IATA code and name.
  class Airport
    include Utils::Validation
    attr_accessor :code, :name
    attr_reader :errors

    def initialize(code:, name:)
      @code = code&.upcase
      @name = name
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "code must be 3-letter IATA" unless valid_iata?(@code)
      @errors << "name required" unless present?(@name)
      @errors.empty?
    end

    def to_h
      { code: @code, name: @name }
    end

    def self.from_h(h)
      new(code: h["code"], name: h["name"])
    end

    def to_s
      "Airport(#{@code}) #{@name}"
    end
  end
end
