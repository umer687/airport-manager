# frozen_string_literal: true
require_relative 'test_helper'
require 'models/flight'
require 'services/flight_service'

class TestFlightDelay < Minitest::Test
  def setup
    @store = Minitest::Mock.new
    @flight = Models::Flight.new(number: "PK101", from: "LHE", to: "KHI", departs_at: Time.now.utc + 3600, arrives_at: Time.now.utc + 7200, aircraft_tail: "A123")
    @store.expect :flights, [@flight]
    @store.expect :save_all, true
    @service = Services::FlightService.new(@store)
  end

  def test_set_delay_marks_flight_as_delayed
    @service.set_delay("PK101", 45)
    assert_equal 45, @flight.delay_minutes
    assert_equal "delayed", @flight.status
  end

  def test_reset_delay_restores_on_time
    @flight.apply_delay(20)
    @flight.status = "delayed"
    @service.reset_delay("PK101")
    assert_equal 0, @flight.delay_minutes
    assert_equal "on-time", @flight.status
  end

  def test_cannot_delay_departed_flight
    @flight.status = "departed"
    assert_raises(RuntimeError) { @service.set_delay("PK101", 30) }
  end
end
