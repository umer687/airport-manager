# frozen_string_literal: true
module Models
  # Aircraft contains capacity, type, and baggage limits.
  class Aircraft
    attr_accessor :tail_number, :model, :capacity, :max_baggage_weight
    attr_reader :errors

    def initialize(tail_number:, model:, capacity:, max_baggage_weight: 500.0)
      @tail_number = tail_number&.upcase
      @model = model
      @capacity = capacity.to_i
      @max_baggage_weight = max_baggage_weight.to_f
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "tail number required" if @tail_number.to_s.strip.empty?
      @errors << "model required" if @model.to_s.strip.empty?
      @errors << "capacity > 0" if @capacity <= 0
      @errors.empty?
    end

    def to_h
      {
        tail_number: @tail_number,
        model: @model,
        capacity: @capacity,
        max_baggage_weight: @max_baggage_weight
      }
    end

    def self.from_h(h)
      new(
        tail_number: h["tail_number"],
        model: h["model"],
        capacity: h["capacity"],
        max_baggage_weight: h["max_baggage_weight"] || 500.0
      )
    end

    def to_s
      "Aircraft(#{@tail_number}) #{@model} cap=#{@capacity}, max_baggage=#{@max_baggage_weight}kg"
    end
  end
end
