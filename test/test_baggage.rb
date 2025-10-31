require_relative 'test_helper'
require 'ostruct'
require 'models/bag'
require 'models/passenger'
require 'models/aircraft'

class TestBaggage < Minitest::Test
  def setup
    @p = Models::Passenger.new(name: "Ali", email: "ali@example.com")
    bag1 = Models::Bag.new(weight: 20)
    @p.bags = [bag1]
  end

  def test_total_weight
    assert_equal 20, @p.total_baggage_weight
    @p.bags << Models::Bag.new(weight: 5)
    assert_equal 25, @p.total_baggage_weight
  end

  def test_over_limit_booking
    require 'services/booking_service'
    # Setup store mock
    store = OpenStruct.new(
      flights: [OpenStruct.new(number: "F1", aircraft_tail: "AP-BX1", status: "scheduled")],
      passengers: [@p],
      aircraft: [Models::Aircraft.new(tail_number: "AP-BX1", model: "A320", capacity: 1, max_baggage_weight: 15)],
      tickets: [],
      bookings: [],
      add_booking: ->(b) {},
      add_ticket: ->(t) {},
      save_all: -> {},
      remove_ticket: ->(id) {}
    )
    service = Services::BookingService.new(store)
    assert_raises(RuntimeError) do
      service.book("F1", "ali@example.com")
    end
  end
end
