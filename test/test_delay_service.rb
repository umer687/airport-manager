# frozen_string_literal: true
require "minitest/autorun"
require_relative "../lib/models/flight"
require_relative "../lib/models/delay_record"
require_relative "../lib/services/delay_service"

class DS_Store
  attr_accessor :flights, :delays
  def initialize
    @flights = []
    @delays = []
  end
  def save_all; true; end
end

class TestDelayService < Minitest::Test
  def setup
    @store = DS_Store.new
    @flight = Models::Flight.new(number: "PK101", origin: "LHE", destination: "KHI", aircraft_tail: "A1", status: "scheduled", delay_minutes: 0)
    @store.flights << @flight
    @svc = Services::DelayService.new(@store)
  end

  def test_record_delay_creates_record_and_updates_flight
    rec = @svc.record_delay(flight_number: "PK101", minutes: 25, reason: "ATC")
    assert_equal 1, @store.delays.size
    assert_equal "PK101", rec.flight_number
    assert_equal "delayed", @flight.status
    assert_equal 25, @flight.delay_minutes
  end

  def test_delete_delay_removes_it
    rec = @svc.record_delay(flight_number: "PK101", minutes: 10)
    assert_equal true, @svc.delete_delay(rec.id)
    assert_empty @store.delays
  end

  def test_delays_for_flight_filters_correctly
    @svc.record_delay(flight_number: "PK101", minutes: 5)
    @svc.record_delay(flight_number: "PK101", minutes: 10)
    list = @svc.delays_for_flight("PK101")
    assert_equal 2, list.size
  end
end
