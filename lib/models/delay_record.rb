# frozen_string_literal: true
require 'securerandom'
require 'time'

module Models
  class DelayRecord
    attr_accessor :id, :flight_number, :minutes_delayed, :reason, :compensation_per_passenger, :created_at
    attr_reader :errors

    def initialize(flight_number:, minutes_delayed:, reason: "", compensation_per_passenger: 0.0, id: nil, created_at: nil)
      @id = id || SecureRandom.uuid
      @flight_number = flight_number
      @minutes_delayed = minutes_delayed.to_i
      @reason = reason.to_s
      @compensation_per_passenger = compensation_per_passenger.to_f
      @created_at = created_at || Time.now.utc.iso8601
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "flight_number required" if @flight_number.to_s.strip.empty?
      @errors << "minutes_delayed must be >= 0" if @minutes_delayed < 0
      @errors.empty?
    end

    def to_h
      {
        id: @id,
        flight_number: @flight_number,
        minutes_delayed: @minutes_delayed,
        reason: @reason,
        compensation_per_passenger: @compensation_per_passenger,
        created_at: @created_at
      }
    end

    def self.from_h(h)
      new(
        id: h["id"],
        flight_number: h["flight_number"],
        minutes_delayed: h["minutes_delayed"] || 0,
        reason: h["reason"] || "",
        compensation_per_passenger: h["compensation_per_passenger"] || 0.0,
        created_at: h["created_at"]
      )
    end
  end
end
