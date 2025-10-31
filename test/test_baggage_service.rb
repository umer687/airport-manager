# frozen_string_literal: true
require 'minitest/autorun'
require_relative '../lib/models/bag'
require_relative '../lib/models/passenger'
require_relative '../lib/services/baggage_service'

class DummyStore
  attr_accessor :passengers
  def initialize
    @passengers = []
  end
  def save_all; end
end

class TestBaggageService < Minitest::Test
  def setup
    @store = DummyStore.new
    @passenger = Models::Passenger.new(
      name: "Ali", email: "ali@example.com", passport_number: "XYZ123"
    )
    @store.passengers << @passenger
    @service = Services::BaggageService.new(@store)
  end

  def test_add_bag
    bag = @service.add_bag("ali@example.com", 15)
    assert_equal 15.0, @passenger.total_baggage_weight
    assert_equal 1, @passenger.bags.size
    assert_instance_of Models::Bag, bag
  end

  def test_remove_bag
    bag = @service.add_bag("ali@example.com", 10)
    @service.remove_bag("ali@example.com", bag.id)
    assert_empty @passenger.bags
    assert_equal 0, @passenger.total_baggage_weight
  end
end
