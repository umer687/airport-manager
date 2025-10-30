# frozen_string_literal: true
require 'utils/validation'

module Models
  class Passenger
    include Utils::Validation
    attr_accessor :name, :email
    attr_reader :errors

    def initialize(name:, email:)
      @name = name
      @email = email&.downcase
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "name required" unless present?(@name)
      @errors << "email invalid" unless valid_email?(@email)
      @errors.empty?
    end

    def to_h; { name: @name, email: @email }; end
    def self.from_h(h); new(name: h["name"], email: h["email"]); end
    def to_s; "Passenger #{@name} <#{email}>"; end
  end
end
