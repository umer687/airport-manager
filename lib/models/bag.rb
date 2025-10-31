# frozen_string_literal: true
require 'securerandom'

module Models
  class Bag
    attr_accessor :id, :weight
    attr_reader :errors

    def initialize(weight:)
      @id = SecureRandom.uuid
      @weight = weight.to_f
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "weight must be > 0" if @weight <= 0
      @errors.empty?
    end

    def to_h
      { id: @id, weight: @weight }
    end

    def self.from_h(h)
      new(weight: h["weight"])
    end
  end
end
