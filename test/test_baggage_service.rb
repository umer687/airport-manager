# frozen_string_literal: true
require "minitest/autorun"
require_relative "../lib/models/passenger"
require_relative "../lib/models/bag"
require_relative "../lib/services/baggage_service"

class TestBaggageService < Minitest::Test
  def setup
    @store = Minitest::Mock.new
    @passenger = Models::Passenger.new(name: "Ali", email: "ali@example.com")
    @store.expect :save_all, true
    @store.expect :passengers, [@passenger]
    @service = Services::BaggageService.new(@store)
  end

  # ✅ 1. Adding a bag increases total weight
  def test_add_bag_increases_total_weight
    @service.add_bag(@passenger.email, 12.5)
    assert_in_delta 12.5, @passenger.total_baggage_weight, 0.01
  end

  # ✅ 2. Removing a bag reduces total weight
  def test_remove_bag_reduces_total_weight
    @service.add_bag(@passenger.email, 10.0)
    @service.add_bag(@passenger.email, 5.0)
    @service.remove_bag(@passenger.email, 5.0)
    assert_in_delta 10.0, @passenger.total_baggage_weight, 0.01
  end

  # ✅ 3. Rejects adding bag if exceeds aircraft weight limit
  def test_add_bag_exceeding_limit_raises_error
    @service.define_singleton_method(:aircraft_limit) { 20.0 }
    @service.add_bag(@passenger.email, 15.0)
    assert_raises(RuntimeError) { @service.add_bag(@passenger.email, 10.0) }
  end

  # ✅ 4. Bag list contains unique IDs
  def test_added_bag_has_unique_id
    @service.add_bag(@passenger.email, 5.0)
    @service.add_bag(@passenger.email, 8.0)
    ids = @passenger.bags.map(&:id)
    assert_equal ids.uniq.size, ids.size
  end

  # ✅ 5. Total weight reflects sum of all registered bags
  def test_total_weight_reflects_all_bags
    @service.add_bag(@passenger.email, 4.5)
    @service.add_bag(@passenger.email, 3.5)
    @service.add_bag(@passenger.email, 2.0)
    assert_in_delta 10.0, @passenger.total_baggage_weight, 0.01
  end
end
