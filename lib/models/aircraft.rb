# frozen_string_literal: true
module Models
  # Aircraft contains capacity and type.
  class Aircraft
    attr_accessor :tail_number, :model, :capacity
    attr_reader :errors

    def initialize(tail_number:, model:, capacity:)
      @tail_number = tail_number&.upcase
      @model = model
      @capacity = capacity.to_i
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
      { tail_number: @tail_number, model: @model, capacity: @capacity }
    end

    def self.from_h(h)
      new(tail_number: h["tail_number"], model: h["model"], capacity: h["capacity"])
    end

    def to_s
      "Aircraft(#{@tail_number}) #{@model} cap=#{@capacity}"
    end
  end
end
