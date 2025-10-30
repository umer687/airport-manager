# frozen_string_literal: true
require_relative 'test_helper'
require 'storage/json_store'
require 'services/booking_service'
require 'models/aircraft'
require 'models/flight'
require 'models/passenger'

class TestBooking < Minitest::Test
  def setup
    @dir = File.join(Dir.pwd, "data_test_#{rand(10000)}")
    Dir.mkdir(@dir) unless Dir.exist?(@dir)
    @store = Storage::JSONStore.new(@dir)
    @store.add_passenger(Models::Passenger.new(name: "Usama", email: "usama@example.com"))
    @store.aircraft << Models::Aircraft.new(tail_number: "AP-BG1", model: "A320", capacity: 1)
    dep = Time.now.utc + 3600
    arr = dep + 7200
    @store.add_flight(Models::Flight.new(number: "PK301", from: "KHI", to: "LHE", departs_at: dep, arrives_at: arr, aircraft_tail: "AP-BG1"))
    @store.save_all
    @svc = Services::BookingService.new(@store)
  end

  def teardown
    Dir[@dir + "/*"].each { |f| File.delete(f) }
    Dir.rmdir(@dir)
  end

  def test_booking_capacity
    t1 = @svc.book("PK301", "usama@example.com")
    assert t1, "first booking should succeed"
    @store.add_passenger(Models::Passenger.new(name: "Ali", email: "ali@example.com"))
    t2 = @svc.book("PK301", "ali@example.com")
    assert_nil t2, "overbooking must fail"
  end

  def test_cancel_ticket
    t = @svc.book("PK301", "usama@example.com")
    assert t, "booking should succeed"
    assert @svc.cancel(t.id), "cancel should succeed"
  end
end
