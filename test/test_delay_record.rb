# frozen_string_literal: true
require "minitest/autorun"
require_relative "../lib/models/delay_record"

class TestDelayRecord < Minitest::Test
  def test_valid_record
    r = Models::DelayRecord.new(flight_number: "PK101", minutes_delayed: 30, reason: "Weather", compensation_per_passenger: 10.5)
    assert r.valid?
    h = r.to_h
    assert_equal "PK101", h[:flight_number]
    assert_equal 30, h[:minutes_delayed]
  end

  def test_invalid_when_missing_flight_number
    r = Models::DelayRecord.new(flight_number: "", minutes_delayed: 10)
    refute r.valid?
  end

  def test_invalid_when_negative_minutes
    r = Models::DelayRecord.new(flight_number: "PK101", minutes_delayed: -5)
    refute r.valid?
  end
end
